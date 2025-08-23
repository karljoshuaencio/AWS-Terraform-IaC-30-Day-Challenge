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


resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "VPC 13"
    }
}

resource "aws_subnet" "this" {
    for_each = var.subnet_cidr
    
    vpc_id = aws_vpc.this.id
    cidr_block = each.value

    tags = {
        Name = "${each.key}-subnet"
    }
}