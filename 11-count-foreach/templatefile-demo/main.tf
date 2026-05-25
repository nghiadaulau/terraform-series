terraform {
  required_version = ">= 1.10"
}

variable "create_extra" {
  type    = bool
  default = false
}

# Tạo có điều kiện: count = điều_kiện ? 1 : 0
# (ở đây minh hoạ bằng local thay vì resource thật)
locals {
  rendered = templatefile("${path.module}/nginx-upstream.tftpl", {
    port     = 8080
    ip_addrs = ["10.0.1.10", "10.0.1.11", "10.0.1.12"]
  })
}

output "nginx_config" {
  value = local.rendered
}

output "extra_count" {
  value = var.create_extra ? 1 : 0
}
