output "vpc_id" {
    description = "id of vpc"
    value = aws_vpc.this.id
}

output "subnet_cidr" {
    description = "subnet cidr"
    value = aws_subnet.this
}