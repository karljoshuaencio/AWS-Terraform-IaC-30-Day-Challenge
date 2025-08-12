resource "aws_vpc" "this" {
    cidr_block =  var.vpc_cidr1

    tags = {
        Name = "vpc1"
    }
}

resource "aws_subnet" "this" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.subnet_cidr1
    
    tags = {
        Name = "subnetday1"
    }
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "igwday1"
    }
}