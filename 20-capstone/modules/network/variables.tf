variable "name" {
  type        = string
  description = "Tên dùng đặt tag cho tài nguyên mạng"
}

variable "vpc_cidr" {
  type        = string
  description = "Dải CIDR của VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = map(string)
  description = "Map: AZ -> CIDR subnet công khai"
}
