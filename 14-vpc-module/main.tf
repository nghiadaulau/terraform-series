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

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Module mạng: dùng cidrsubnet sinh CIDR cho 2 AZ đầu tiên.
module "network" {
  source   = "./modules/network"
  name     = "tf-series-bai14"
  vpc_cidr = "10.0.0.0/16"
  public_subnets = {
    (data.aws_availability_zones.available.names[0]) = cidrsubnet("10.0.0.0/16", 8, 0) # 10.0.0.0/24
    (data.aws_availability_zones.available.names[1]) = cidrsubnet("10.0.0.0/16", 8, 1) # 10.0.1.0/24
  }
}

resource "aws_security_group" "web" {
  name_prefix = "tf-series-bai14-"
  description = "Cho phep HTTP"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 đặt vào subnet công khai đầu tiên của module mạng.
resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = module.network.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.web.id]
  tags                   = { Name = "tf-series-bai14-web" }
}

output "vpc_id" {
  value = module.network.vpc_id
}
output "subnet_ids" {
  value = module.network.public_subnet_ids
}
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
