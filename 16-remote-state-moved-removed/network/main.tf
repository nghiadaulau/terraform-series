terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}
provider "aws" { region = "ap-southeast-1" }

resource "aws_s3_bucket" "shared" {
  bucket_prefix = "tf-series-bai16-net-"
  force_destroy = true
}

# Output này là thứ config khác sẽ đọc qua terraform_remote_state.
output "bucket_name" { value = aws_s3_bucket.shared.id }
