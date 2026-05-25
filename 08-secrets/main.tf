terraform {
  required_version = ">= 1.11" # write-only args cần 1.11+

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

variable "secret_value" {
  type      = string
  sensitive = true
  default   = "p@ssw0rd-bai8-demo"
}

# --- Cách CŨ: secret_string -> giá trị BỊ ghi vào state ---
resource "aws_secretsmanager_secret" "legacy" {
  name                    = "tf-series-bai8-legacy"
  recovery_window_in_days = 0 # xóa ngay khi destroy (lab)
}

resource "aws_secretsmanager_secret_version" "legacy" {
  secret_id     = aws_secretsmanager_secret.legacy.id
  secret_string = var.secret_value
}

# --- Cách MỚI: secret_string_wo (write-only) -> giá trị KHÔNG vào state ---
resource "aws_secretsmanager_secret" "wo" {
  name                    = "tf-series-bai8-wo"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "wo" {
  secret_id                = aws_secretsmanager_secret.wo.id
  secret_string_wo         = var.secret_value
  secret_string_wo_version = 1 # tăng số này khi muốn cập nhật secret
}
