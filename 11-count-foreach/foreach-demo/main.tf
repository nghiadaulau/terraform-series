terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}
provider "aws" { region = "ap-southeast-1" }

variable "names" {
  type    = set(string)
  default = ["alpha", "beta", "gamma"]
}

# for_each: tạo bản theo KHÓA (mỗi tên là một khóa ổn định)
resource "aws_s3_bucket" "b" {
  for_each      = var.names
  bucket_prefix = "tf-series-bai11-${each.key}-"
  force_destroy = true
}
