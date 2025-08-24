resource "aws_vpc" "this" {
    cidr_block = var.cidr_vpc

    tags = {
        Name = "Day 14 VPC"
    }
}

resource "aws_subnet" "this" {
    for_each = var.cidr_subnet
    vpc_id = aws_vpc.this.id

    cidr_block = each.value

    tags = {
        Name = "${each.key}-subnet"
    }

}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "igw14"
    }
}