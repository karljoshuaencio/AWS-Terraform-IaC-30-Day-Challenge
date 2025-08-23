variable "vpc_cidr_block" {
    description = "VPC Cidr Block"
    type = string
}

variable "public_cidr" {
    description = "Public Subnet CIDR Block" 
    type = string
}

variable "private_cidr" {
    description = "Private Subnet CIDR BLOCK"
    type = string
}