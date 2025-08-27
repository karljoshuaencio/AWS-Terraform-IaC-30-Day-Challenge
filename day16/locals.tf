locals {
    instance_type_map = {
        dev = "t2.micro"
        staging = "t3.small"
        prod = "t3.medium"
    }

    instance_type = lookup(local.instance_type_map, terraform.workspace, "t2.micro")
}