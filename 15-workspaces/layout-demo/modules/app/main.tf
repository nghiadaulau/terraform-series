resource "aws_s3_bucket" "app" {
  bucket_prefix = "tf-series-bai15-${var.environment}-"
  force_destroy = true
  tags = {
    Environment = var.environment
    Size        = var.instance_type
  }
}
