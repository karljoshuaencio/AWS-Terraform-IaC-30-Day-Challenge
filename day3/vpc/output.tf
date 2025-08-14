output "private_ec2_id" {
  value = aws_instance.private.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "nat_gateway_ip" {
  value = aws_eip.nat.public_ip
}