output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Danh sách id các subnet công khai"
  value       = [for s in aws_subnet.public : s.id]
}
