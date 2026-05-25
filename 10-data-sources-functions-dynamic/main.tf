terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# --- data sources: ĐỌC thông tin có sẵn trên AWS (không tạo gì) ---

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# AMI Amazon Linux 2023 mới nhất, do Amazon phát hành.
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

data "aws_vpc" "default" {
  default = true
}

# --- for expression: biến đổi/lọc collection ---
variable "allowed_ports" {
  type    = list(number)
  default = [80, 443, 22]
}

locals {
  # for tạo list các rule từ danh sách cổng (bỏ cổng 22 cho ví dụ "if").
  web_ports = [for p in var.allowed_ports : p if p != 22]
  # for tạo map: cổng -> mô tả
  port_desc = { for p in var.allowed_ports : p => "cho phép cổng ${p}" }
}

# --- dynamic block: sinh các block lồng (ingress) lặp lại ---
resource "aws_security_group" "web" {
  name_prefix = "tf-series-bai10-"
  description = "Demo dynamic block"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = local.web_ports
    content {
      description = "HTTP/HTTPS ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Project = "tf-series" }
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
output "az_names" {
  value = data.aws_availability_zones.available.names
}
output "latest_al2023_ami" {
  value = data.aws_ami.al2023.id
}
output "web_ports" {
  value = local.web_ports
}
output "port_desc" {
  value = local.port_desc
}
