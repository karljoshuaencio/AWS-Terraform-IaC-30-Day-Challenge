output "s3_bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "cloudtrail_name" {
  value = aws_cloudtrail.this.name
}
