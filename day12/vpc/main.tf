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
    cidr_block = var.vpc_cidr_block

    tags = {
        Name = "Day 12 VPC"
    }
}

data "aws_vpc" "lookup" {
    id = aws_vpc.this.id
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.public_cidr
    map_public_ip_on_launch = true

    tags = {
        Name = "Public Subnet"
    }
}

data "aws_subnet" "lookup" {
    id = aws_subnet.public.id
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.private_cidr

    tags = {
        Name = "Private Subnet"
    }
}

data "aws_subnet_private" "lookup" {
    id = aws_subnet.private.id
}

resource "aws_internet_gateway" "igw12" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "Internet Gateway Day 12"
    }
}

data "aws_internet_gateway" "lookup" {
    id = aws_internet_gateway.igw12.id
}
