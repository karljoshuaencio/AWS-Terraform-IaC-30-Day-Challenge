output "vpc_id" {
    value = aws_vpc.this.id
    description = "VPC ID"
}

output "subnet_id" {
    value = aws_subnet.this.id
    description = "SUBNET ID"
}

output "igw_id" {
    value = aws_internet_gateway.this.id
    description = "IGW ID"
}