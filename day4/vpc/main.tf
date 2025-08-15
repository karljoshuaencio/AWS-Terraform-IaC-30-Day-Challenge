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
    assign_generated_ipv6_cidr_block = true
    tags = {
        Name = "vpc"
    }
}

resource "aws_subnet" "this" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.subnet_cidr
    ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block ,8, 0)

}

resource "aws_security_group" "allow_tls" {
    name = "allow_tls"
    description = "ALLOW TLS inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "allow_tls"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
    security_group_id = aws_security_group.allow_tls.id
    cidr_ipv4 = var.vpc_cidr
    from_port = 443
    ip_protocol = "tcp"
    to_port = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
    security_group_id = aws_security_group.allow_tls.id
    cidr_ipv6 = aws_vpc.this.ipv6_cidr_block
    from_port = 443
    ip_protocol = "tcp"
    to_port = 443

}