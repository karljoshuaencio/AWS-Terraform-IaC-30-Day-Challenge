output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.this.id
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_public_ip" {
  description = "The Elastic IP of the EC2 instance"
  value       = aws_eip.this.public_ip
}

output "instance_public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = aws_instance.this.public_dns
}

output "security_group_id" {
  description = "The security group ID for the EC2 instance"
  value       = aws_security_group.this.id
}
