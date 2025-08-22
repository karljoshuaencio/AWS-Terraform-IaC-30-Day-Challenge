output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "website_url" {
  value = "https://${var.domain_name}"
}
