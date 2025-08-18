variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "s3_bucket_name" {
  description = "S3 bucket for Terraform state"
  type        = string
  default     = "day7-tf-state-bucket"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table for Terraform state locking"
  type        = string
  default     = "day7-tf-locks"
}
