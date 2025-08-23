variable "vpc_cidr" {
    description = "AWS VPC DAY 13"
    type = string
}

variable "subnet_cidr" {
    description = "Subnet CIDR"
    type = map(string)
}