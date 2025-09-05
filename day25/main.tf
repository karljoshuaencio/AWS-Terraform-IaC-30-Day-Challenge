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


resource "aws_security_group" "rds_sg" {
  name = "day25-rds-sg"
  description = "allow mysql access"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.ec2_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "day25-rds-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "this" {
  identifier              = "day25-rds"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "laundrydb"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
}

resource "aws_dynamodb_table" "reminders" {
  name         = "laundry_reminders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"
  range_key    = "reminder_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "reminder_id"
    type = "S"
  }
}