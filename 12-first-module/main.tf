terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# Gọi cùng MỘT module hai lần với đầu vào khác nhau -> hai bucket, không chép code.
module "logs" {
  source        = "./modules/secure-bucket"
  name_prefix   = "tf-series-bai12-logs-"
  force_destroy = true
  tags          = { Purpose = "logs" }
}

module "data" {
  source        = "./modules/secure-bucket"
  name_prefix   = "tf-series-bai12-data-"
  versioning    = false
  force_destroy = true
  tags          = { Purpose = "data" }
}

# Truy cập output của module qua module.<tên>.<output>
output "logs_bucket" {
  value = module.logs.id
}

output "data_bucket_arn" {
  value = module.data.arn
}
