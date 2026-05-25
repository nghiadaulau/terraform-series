terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}
provider "aws" { region = "ap-southeast-1" }

variable "names" {
  type    = list(string)
  default = ["alpha", "beta", "gamma"]
}

# count: tạo N bản gần như giống nhau, địa chỉ theo CHỈ SỐ [0],[1],[2]
resource "aws_s3_bucket" "b" {
  count         = length(var.names)
  bucket_prefix = "tf-series-bai11-${var.names[count.index]}-"
  force_destroy = true
}
