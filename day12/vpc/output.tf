output "Public_Cidr" {
    value = var.public_cidr
}

output "private_cidr" {
  value = var.private_cidr
}

output "vpc" {
    value = aws_vpc.this.id
}

output "igw" {
    value = aws_internet_gateway.igw12.id
}

output "vpc_from_data" {
    value = data.aws_vpc.lookup.id
}

output "subnet_from_data" {
    value = data.aws_subnet.public.id
}

output "internet_gateway" {
    value = data.aws_internet_gateway.lookup.id
}