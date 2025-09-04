variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "public_subnet" {
  default = "10.1.1.0/24"
}

variable "availability_zone" {
  default = "ap-southeast-1a"
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
