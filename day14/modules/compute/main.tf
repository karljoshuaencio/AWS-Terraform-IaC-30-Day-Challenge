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


resource "aws_instance" "this" {
    count = var.instance_count
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = element(values(var.subnet_ids), count.index)
    tags = {
        Name = "EC2-${count.index +1}-Day14"
    }
}