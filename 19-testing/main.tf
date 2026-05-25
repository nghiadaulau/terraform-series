terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}
provider "aws" { region = "ap-southeast-1" }

variable "project" {
  type = string
}
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment phải là dev, staging hoặc prod."
  }
}

locals {
  bucket_name = "${var.project}-${var.environment}-data"
}

resource "aws_s3_bucket" "data" {
  bucket = local.bucket_name
  tags   = { Environment = var.environment }
}

output "bucket_name" { value = aws_s3_bucket.data.bucket }
