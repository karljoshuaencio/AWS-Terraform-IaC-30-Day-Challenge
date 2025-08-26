provider "aws" {
  alias  = "bootstrap"
  region = var.region
}

data "aws_secretsmanager_secret" "creds" {
  provider = aws.bootstrap
  name     = var.secret_name
}

data "aws_secretsmanager_secret_version" "creds" {
  provider  = aws.bootstrap
  secret_id = data.aws_secretsmanager_secret.creds.id
}

provider "aws" {
  region     = var.region
  access_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string).access_key
  secret_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string).secret_key
}


# IAM Role

resource "aws_iam_role" "Day15Role" {
  name        = var.role_name
  description = "IAM Role for Day 15 Exercise"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = "Day15"
  }
}


# IAM Policy

resource "aws_iam_policy" "Day15Policy" {
  name        = var.policy_name
  description = "IAM Policy for Day 15 Exercise"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe*"]
        Resource = "*"
      }
    ]
  })
}


# Attach Policy to Role

resource "aws_iam_role_policy_attachment" "Day15RoleAttach" {
  role       = aws_iam_role.Day15Role.name
  policy_arn = aws_iam_policy.Day15Policy.arn
}

# IAM User
resource "aws_iam_user" "lb" {
  name = var.user_name
  path = "/system/"

  tags = {
    Environment = "Day15"
  }
}

# Access Key for User
resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.lb.name
}


# Inline Policy for User

data "aws_iam_policy_document" "lb_ro" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "lb_ro" {
  name   = "LBInlinePolicy"
  user   = aws_iam_user.lb.name
  policy = data.aws_iam_policy_document.lb_ro.json
}
