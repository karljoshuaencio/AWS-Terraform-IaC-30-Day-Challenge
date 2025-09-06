variable "region" {
  description = "Default AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "bucket_name" {
  description = "S3 bucket name for static site"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the site"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for the domain"
  type        = string
}
