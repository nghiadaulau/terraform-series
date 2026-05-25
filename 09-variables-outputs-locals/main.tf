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
  region = var.region
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project" {
  type        = string
  description = "Tên dự án, dùng để đặt tiền tố tài nguyên"
  default     = "tf-series"
}

variable "environment" {
  type        = string
  description = "Môi trường: dev | staging | prod"
  default     = "dev"

  # validation: chặn giá trị sai NGAY ở bước plan, kèm thông báo rõ ràng.
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment phải là một trong: dev, staging, prod."
  }
}

variable "force_destroy" {
  type        = bool
  description = "Cho phép xóa bucket kèm object. KHÔNG nên bật ở prod."
  default     = true
}

# locals: đặt tên cho biểu thức dẫn xuất, tránh lặp.
locals {
  name_prefix   = "${var.project}-${var.environment}"
  is_production = var.environment == "prod"
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket" "app" {
  bucket_prefix = "${local.name_prefix}-"
  force_destroy = var.force_destroy
  tags          = local.common_tags

  # precondition: ở prod không cho phép force_destroy (chống xóa nhầm dữ liệu).
  # Tham chiếu var/local, KHÔNG dùng self (precondition chạy trước khi tạo).
  lifecycle {
    precondition {
      condition     = !local.is_production || !var.force_destroy
      error_message = "Ở prod không được bật force_destroy trên bucket."
    }
  }
}

output "bucket_name" {
  value = aws_s3_bucket.app.id
}

output "name_prefix" {
  value = local.name_prefix
}
