variable "ami_id" {
    description = "ami id"
    type = string
}

variable "instance_type" {
    description = "instance type of ec2"
    type = string
}

variable "subnet_ids" {
    description = "subnet of ec2"
    type = map(string)
}

variable "instance_count" {
    description = "how many ec2"
    type = number
}