# Module "secure-bucket": đóng gói một bucket S3 kèm versioning, mã hóa,
# và chặn public — một khái niệm "bucket an toàn" thay vì 4 resource rời.
# Module KHÔNG khai provider; nó kế thừa provider từ root gọi nó.

resource "aws_s3_bucket" "this" {
  bucket_prefix = var.name_prefix
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
