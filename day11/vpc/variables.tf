variable "bucket_name" {
  description = "The name of the S3 bucket for hosting the website"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the website (must be in Route53)"
  type        = string
}

variable "route53_zone_id" {
  description = "The Route53 hosted zone ID for the domain"
  type        = string
}
