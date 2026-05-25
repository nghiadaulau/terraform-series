terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}
provider "aws" { region = "ap-southeast-1" }

# Cấu hình thay đổi theo workspace hiện tại qua terraform.workspace.
locals {
  instance_type = terraform.workspace == "prod" ? "t3.small" : "t3.micro"
}

resource "aws_s3_bucket" "app" {
  bucket_prefix = "tf-series-bai15-${terraform.workspace}-"
  force_destroy = true
  tags = {
    Workspace = terraform.workspace
    Size      = local.instance_type
  }
}

output "workspace"     { value = terraform.workspace }
output "bucket"        { value = aws_s3_bucket.app.id }
output "instance_type" { value = local.instance_type }
