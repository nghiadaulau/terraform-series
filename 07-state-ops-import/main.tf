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

# import block (config-driven, từ Terraform 1.5): đưa một resource CÓ SẴN
# (dựng tay từ trước) vào quản lý của Terraform.
#   - to: địa chỉ resource trong cấu hình
#   - id: id thật trên AWS (với S3 là tên bucket)
#
# Quy trình:
#   1. terraform plan -generate-config-out=generated.tf   # sinh resource block
#   2. xem lại generated.tf rồi gộp vào cấu hình
#   3. terraform apply                                     # thực hiện import
#   4. (tuỳ chọn) xoá import block sau khi import xong
#
# Đổi id dưới đây thành tên bucket có sẵn của bạn trước khi chạy.
import {
  to = aws_s3_bucket.adopted
  id = "REPLACE_WITH_EXISTING_BUCKET_NAME"
}
