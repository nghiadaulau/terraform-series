output "id" {
  description = "Tên (id) bucket"
  value       = aws_s3_bucket.this.id
}

output "arn" {
  description = "ARN bucket"
  value       = aws_s3_bucket.this.arn
}
