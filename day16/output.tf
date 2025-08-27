output "workspace" {
    value = terraform.workspace
}

output "instance_type" {
    value = local.instance_type
}

output "aws_instance" {
    value = aws_instance.this.id
}