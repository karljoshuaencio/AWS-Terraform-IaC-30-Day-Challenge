output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "ec2_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "s3_bucket_name" {
  description = "S3 bucket for ALB logs"
  value       = aws_s3_bucket.this.bucket
}
