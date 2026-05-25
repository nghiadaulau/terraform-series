terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}
provider "aws" { region = "ap-southeast-1" }

variable "app_version" {
  type    = string
  default = "v1"
}

resource "aws_s3_bucket" "important" {
  bucket_prefix = "tf-series-bai17-"
  force_destroy = true

  lifecycle {
    prevent_destroy = true # chặn destroy nhầm (tắt khi thật sự muốn xóa)
    ignore_changes  = [tags]
  }
}

# terraform_data: thay null_resource. triggers_replace -> tạo lại khi giá trị đổi.
resource "terraform_data" "deploy_marker" {
  triggers_replace = [var.app_version]
  input            = "deployed ${var.app_version}"
}

# check block (1.5): kiểm tra ngoài vòng đời, chỉ CẢNH BÁO, không chặn apply.
check "bucket_naming" {
  assert {
    condition     = startswith(aws_s3_bucket.important.id, "tf-series")
    error_message = "Tên bucket nên bắt đầu bằng 'tf-series'."
  }
}

output "marker" { value = terraform_data.deploy_marker.output }
