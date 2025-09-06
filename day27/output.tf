output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "ec2_cpu_alarm" {
  value = aws_cloudwatch_metric_alarm.ec2_cpu_high.alarm_name
}

output "rds_storage_alarm" {
  value = aws_cloudwatch_metric_alarm.rds_storage_low.alarm_name
}

output "cloudfront_5xx_alarm" {
  value = aws_cloudwatch_metric_alarm.cf_5xx_high.alarm_name
}
