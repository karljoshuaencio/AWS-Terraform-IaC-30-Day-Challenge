output "subnet" {
    value = { for k, s in aws_subnet.this : k => s.id}
}

output "vpc" {
    value = var.cidr_vpc
}