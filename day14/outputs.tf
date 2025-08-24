output "ec2_type" {
    value = module.network.vpc
}

output "subnets" {
    value = module.network.subnet
}

output "instnace_id" {
    value = module.compute.instance_ids
}