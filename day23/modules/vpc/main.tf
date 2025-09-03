resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day23-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "day23-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = { Name = "day23-public-${count.index}" }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "day23-private-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "day23-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
