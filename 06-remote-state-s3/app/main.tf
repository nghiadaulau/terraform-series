terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Remote state trên S3. Backend KHÔNG dùng được biến -> điền giá trị tĩnh.
  # use_lockfile bật khóa state native của S3 (tạo object <key>.tflock).
  # Đây là cách hiện hành; KHÔNG còn cần DynamoDB (đã deprecated).
  backend "s3" {
    bucket       = "tf-series-state-20260525030320917300000001"
    key          = "app/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "app" {
  bucket_prefix = "tf-series-bai6-app-"
  force_destroy = true
}

output "app_bucket" {
  value = aws_s3_bucket.app.id
}
