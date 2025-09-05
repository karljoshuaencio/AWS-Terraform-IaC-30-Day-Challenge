output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "aws_dynamodb_table" {
  value = aws_dynamodb_table.reminders.name
}