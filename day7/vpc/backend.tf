# terraform {
#   backend "s3" {
#     bucket         = "day7-tf-state-bucket"
#     key            = "terraform.tfstate"
#     region         = "ap-southeast-1"
#     dynamodb_table = "day7-tf-locks" 
#     encrypt        = true
#   }
# }
