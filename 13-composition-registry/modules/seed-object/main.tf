resource "aws_s3_object" "readme" {
  bucket  = var.bucket_id
  key     = "README.txt"
  content = "Bucket khoi tao boi module seed-object."
}
