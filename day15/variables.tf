variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "secret_name" {
  description = "AWS Secrets Manager secret name"
  type        = string
}

variable "role_name" {
  description = "Name of the IAM Role"
  type        = string
  default     = "Day15Role"
}

variable "policy_name" {
  description = "Name of the IAM Policy"
  type        = string
  default     = "Day15Policy"
}

variable "user_name" {
  description = "Name of the IAM User"
  type        = string
  default     = "loadbalancer"
}
