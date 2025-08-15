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
        Name = "vpc"
    }
}

resource "aws_subnet" "this" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.public_cidr
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "subnet"
    }
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "igwday5"
    }
}


resource "aws_route_table" "this" {
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }
}

resource "aws_security_group" "this" {
    vpc_id = aws_vpc.this.id

    tags = { 
        Name = "allow_tls"
    }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
    security_group_id = aws_security_group.this.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    ip_protocol = "tcp"
    to_port = 443
}

resource "aws_instance" "this" {
    ami  = "ami-09c14d3d53917617b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.this.id
    vpc_security_group_ids = [aws_security_group.this.id]
    tags = {
        Name = "ec2 instance"
    }
  
}

resource "aws_eip" "this" {
    instance = aws_instance.this.id
    domain = "vpc"
  
  tags = {
    Name = "eipday5"
  }
}

