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

resource "aws_s3_bucket" "data" {
  bucket_prefix = "tf-series-bai5-"
  force_destroy = true
}

# Phụ thuộc NGẦM: tham chiếu aws_s3_bucket.data.id tạo ra một cạnh trong đồ thị.
# Terraform tự biết phải tạo bucket TRƯỚC, rồi mới bật versioning.
resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id

  versioning_configuration {
    status = "Enabled"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.data.id
}
