variable "cidr_vpc" {
    description = "vpc cidr block" 
    type = string
}

variable "cidr_subnet" {
    description = "subnet"
    type = map(string)
}

variable "ami_id" {
    description = "ami id of the ec2"
    type = string
}

variable "instance_type" {
    description = "instance type of ec2"
    type = string
}

variable "instance_count" {
    description = "instance count of ec2"
    type = number
}