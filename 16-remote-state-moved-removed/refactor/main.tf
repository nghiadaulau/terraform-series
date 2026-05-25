terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}
provider "aws" { region = "ap-southeast-1" }

# removed block: gỡ resource khỏi quản lý mà KHÔNG destroy (destroy = false).
removed {
  from = aws_s3_bucket.new_name
  lifecycle {
    destroy = false
  }
}
