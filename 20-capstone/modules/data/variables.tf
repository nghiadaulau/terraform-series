variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "app_security_group_id" {
  type        = string
  description = "SG của app được phép kết nối DB"
}
variable "db_password_wo" {
  type        = string
  description = "Mật khẩu DB (write-only, không vào state)"
  sensitive   = true
}
