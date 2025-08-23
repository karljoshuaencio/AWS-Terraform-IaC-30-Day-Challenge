output "subnet_ids" {
    description = "ids of subnet"
    value = { for k, s in aws_subnet.this :k => s.id}
}