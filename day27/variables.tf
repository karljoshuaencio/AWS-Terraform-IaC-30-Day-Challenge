variable "alert_email" {
  description = "Email address for receiving alerts"
  type        = string
}

variable "asg_name" {
  description = "Name of your Auto Scaling Group"
  type        = string
}

variable "rds_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  type        = string
}
