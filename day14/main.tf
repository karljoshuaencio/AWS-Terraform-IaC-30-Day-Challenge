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

module "network" {
  source = "./modules/network"
  cidr_vpc = var.cidr_vpc
  cidr_subnet = var.cidr_subnet
}

module "compute" {
  source = "./modules/compute"
  ami_id = var.ami_id
  instance_type = var.instance_type
  instance_count = var.instance_count
  subnet_ids = module.network.subnet
}