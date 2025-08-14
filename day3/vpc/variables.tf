variable "vpc_cidr" {
  default = "10.3.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.3.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.3.2.0/24"
}

variable "my_ip" {
  description = "Your public IP with /32 for SSH"
}

variable "ami_id" {
  description = "AMI ID for EC2"
}

variable "instance_type" {
  default = "t2.micro"
}