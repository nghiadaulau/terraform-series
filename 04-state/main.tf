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

resource "aws_s3_bucket" "demo" {
  bucket_prefix = "tf-series-bai4-"
  force_destroy = true

  tags = {
    Project = "terraform-series"
    Env     = "dev"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.demo.id
}
