output "alb_dns_name" {
  description = "DNS của ALB để truy cập ứng dụng"
  value       = aws_lb.this.dns_name
}

output "instance_security_group_id" {
  value = aws_security_group.instance.id
}
