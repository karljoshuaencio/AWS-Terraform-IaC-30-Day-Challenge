provider "aws" {
  alias  = "bootstrap"
  region = "us-east-1"
}

data "aws_secretsmanager_secret" "creds" {
  provider = aws.bootstrap
  name     = "terraform/aws-credentials"
}

data "aws_secretsmanager_secret_version" "creds" {
  provider  = aws.bootstrap
  secret_id = data.aws_secretsmanager_secret.creds.id
}

provider "aws" {
  region     = "ap-southeast-1"
  access_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string).access_key
  secret_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string).secret_key
}


resource "aws_sns_topic" "alerts" {
  name = "day27-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email  
}


resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "EC2-High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "Alert if EC2 CPU > 80% for 10 minutes"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}


resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  alarm_name          = "RDS-Low-Storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 1000000000 

  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }

  alarm_description = "Alert if RDS free storage < 1 GB"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}


resource "aws_cloudwatch_metric_alarm" "cf_5xx_high" {
  alarm_name          = "CloudFront-High-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = 300
  statistic           = "Average"
  threshold           = 5

  dimensions = {
    DistributionId = var.cloudfront_distribution_id
    Region         = "Global"
  }

  alarm_description = "Alert if CloudFront 5xx errors > 5%"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}