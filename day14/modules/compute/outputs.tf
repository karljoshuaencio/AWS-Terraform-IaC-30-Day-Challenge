output "ami_id" {
    value = var.ami_id
}

output "instance_type" {
    value = var.instance_type
}

output "instance_ids" {
    value = aws_instance.this[*].id
}