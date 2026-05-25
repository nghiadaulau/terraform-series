terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Dùng profile default (~/.aws/credentials). Chỉ cần khai báo region.
provider "aws" {
  region = "ap-southeast-1"
}

# Resource đầu tiên: một bucket S3.
# bucket_prefix để AWS tự thêm hậu tố ngẫu nhiên -> tên toàn cục không đụng ai.
# force_destroy = true để destroy được kể cả khi bucket còn object (chỉ nên bật ở lab).
resource "aws_s3_bucket" "first" {
  bucket_prefix = "tf-series-bai2-"
  force_destroy = true

  tags = {
    Project = "terraform-series"
    Bai     = "02"
  }
}

output "bucket_name" {
  description = "Tên thật của bucket sau khi tạo"
  value       = aws_s3_bucket.first.id
}

output "bucket_arn" {
  value = aws_s3_bucket.first.arn
}
