variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_cidr" {
  description = "Public subnet CIDR block"
  type        = string
}

variable "private_cidr" {
  description = "Private subnet CIDR block"
  type        = string
}

variable "public_rt_cidr" {
  description = "CIDR for public route table"
  type        = string
}