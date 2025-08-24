variable "cidr_vpc" {
    description = "cidr_vpc"
    type = string
}

variable "cidr_subnet" {
    description = "cidr_subnet"
    type = map(string)
}