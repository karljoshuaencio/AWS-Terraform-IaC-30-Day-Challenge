provider "aws" {
  alias  = "bootstrap"
  region = "ap-southeast-1"
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

resource "aws_instance" "this" {
    ami = var.ami_id
    instance_type = var.instance_type

    tags = {
        Name = "Day 19 Instance"
    }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = "ec2-instance-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period ="120"
  statistic = "Average"
  threshold = "80"
  alarm_description = "cpu utilization"

  dimensions = {
    InstanceId = aws_instance.this.id
  }  
  insufficient_data_actions = []
}


resource "aws_db_instance" "this" {
  identifier              = "day19-rds"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "day8db"
  username                = "admin"
  password                = "Password123!"
  skip_final_snapshot     = true

  tags = {
    Name = "day19-rds"
  }
}


resource "aws_cloudwatch_metric_alarm" "rds_cpu_alarm" {
  alarm_name          = "rds-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm when RDS CPU >= 80%"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }

  insufficient_data_actions = []
}
