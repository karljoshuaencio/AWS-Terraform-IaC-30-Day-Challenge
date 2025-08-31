provider "aws" {
  alias  = "bootstrap"
  region = "ap-southeast-1"
}

data "aws_secretsmanager_secret" "creds" {
  provider = aws.bootstrap
  name     = "terraform/aws-credentials"
}

data "aws_secretsmanager_secret_version" "creds" {
  provider  = aws.bootstrap
  secret_id = data.aws_secretsmanager_secret.creds.id
}

provider "aws" {
  region     = "ap-southeast-1"
  access_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string).access_key
  secret_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string).secret_key
}


resource "aws_secretsmanager_secret" "db" {
    name = "day20-db-credentials"
    description = "db credentials for day 20"
}

resource "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.admin
    password = var.password
  })
}

resource "aws_db_instance" "this" {
    identifier = "day20-rds"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    db_name = "day20db"
    username            = jsondecode(aws_secretsmanager_secret_version.db_creds.secret_string).username
    password            = jsondecode(aws_secretsmanager_secret_version.db_creds.secret_string).password
    allocated_storage = 20
    skip_final_snapshot = true
}