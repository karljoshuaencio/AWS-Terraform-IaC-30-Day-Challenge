output "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket hosting the site"
  value       = aws_s3_bucket.site_bucket.bucket
}

output "certificate_arn" {
  description = "ACM Certificate ARN"
  value       = aws_acm_certificate.cert.arn
}
