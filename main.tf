# provider "aws" {
#   alias  = "bootstrap"
#   region = "ap-southeast-1"
# }

# data "aws_secretsmanager_secret" "creds" {
#   provider = aws.bootstrap
#   name     = "terraform/aws-credentials"
# }

# data "aws_secretsmanager_secret_version" "creds" {
#   provider  = aws.bootstrap
#   secret_id = data.aws_secretsmanager_secret.creds.id
# }

# provider "aws" {
#   region     = "ap-southeast-1"
#   access_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string).access_key
#   secret_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string).secret_key
# }

# # module "vpc_day1" {
# #   source       = "./modules/vpc/"
# #   vpc_cidr1    = "10.0.0.0/16"
# #   subnet_cidr1 = "10.0.1.0/24"
# #   vpc_day1     = "vpc_day1"
# #   vpc_subnet1  = "subnet_day1"
# #   igwday1      = "igw_day1"
# # }

# module "day2" {
#   source         = "./day2/vpc/"
#   vpc_cidr       = var.vpc_cidr
#   public_cidr    = var.public_cidr
#   private_cidr   = var.private_cidr
#   public_rt_cidr = var.public_rt_cidr
# }


