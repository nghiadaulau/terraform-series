terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}

# Provider mặc định: Singapore
provider "aws" {
  region = "ap-southeast-1"
}

# Provider có alias: Bắc Virginia (đa vùng trong cùng một cấu hình)
provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

resource "aws_s3_bucket" "sg" {
  bucket_prefix = "tf-series-bai17-sg-"
  force_destroy = true
}

resource "aws_s3_bucket" "us" {
  provider      = aws.us # dùng provider alias -> tạo ở us-east-1
  bucket_prefix = "tf-series-bai17-us-"
  force_destroy = true
}

output "sg_region" { value = aws_s3_bucket.sg.region }
output "us_region" { value = aws_s3_bucket.us.region }
