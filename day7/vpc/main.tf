provider "aws" {
  alias  = "bootstrap"
  region = var.region
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
  region     = var.region
  access_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string).access_key
  secret_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string).secret_key
}

resource "aws_s3_bucket" "tf_state" {
  bucket = var.s3_bucket_name
  force_destroy = true
  tags = {
    Name = var.s3_bucket_name
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = var.dynamodb_table_name
  }
}
