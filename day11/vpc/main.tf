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

resource "aws_s3_bucket" "this" {
    bucket = "day-11-bucket"

    tags = {
        Name = "Day 11 Bucket"
    }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  }
}


resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


resource "aws_s3_bucket_policy" "website_policy" {
    bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = ["s3:GetObject"],
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

resource "aws_acm_certificate" "cert" {
    provider = aws.us_east_1
    domain_name = var.domain_name
    validation_method = "DNS"

    lifecycle {
      create_before_destroy = true
    }
}

 
resource  "aws_route53_record" "cert_validation" {
    name = tolist(aws_acm_certificate.cert.domain_validation_options[0].resource_record_name)
    type = tolist(aws_acm_certificate.cert.domain_validation_options[0].resource_record_name)
    zone_id = var.route53_zone_id
    records = tolist(aws_acm_certificate.cert.domain_validation_options[0].resource_record_name)
    ttl = 60
}

resource "aws_acn_certificate" "cert" {
    provider = aws.us_east_1
    certicate_arm = aws_acm_certificate.cert.arn
    validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

resource "aws_cloudfront_distribution" "cdn" {
    enabled = true
    default_root_object = "index.html"

    origin {
        domain_name = aws_s3_bucket.bucket_regional_domain_name
        origin_id = "s3-origin"
    }
    default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
    ssl_support_method  = "sni-only"
  }

  aliases = [var.domain_name]
}

resource "aws_route53_record" "alias" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}