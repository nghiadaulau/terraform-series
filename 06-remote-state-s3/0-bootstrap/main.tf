# Bootstrap: tạo bucket S3 để chứa remote state cho các cấu hình khác.
# Bản thân bootstrap dùng local state (con gà - quả trứng: chưa có bucket thì
# chưa thể để state trên S3). Chỉ chạy một lần, hiếm khi đổi.

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

resource "aws_s3_bucket" "state" {
  bucket_prefix = "tf-series-state-"
  force_destroy = true # chỉ để dọn lab cho gọn; KHÔNG bật ở thật
}

# Bật versioning: mỗi lần state đổi, S3 giữ lại bản cũ -> khôi phục được khi hỏng.
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Mã hóa mặc định phía server (state chứa giá trị nhạy cảm).
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Chặn mọi truy cập public.
resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "state_bucket" {
  value = aws_s3_bucket.state.id
}
