output "db_endpoint" { value = aws_db_instance.this.endpoint }
output "assets_bucket" { value = aws_s3_bucket.assets.id }
