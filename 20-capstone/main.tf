terraform {
  required_version = ">= 1.11"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
  # Thực tế: backend "s3" { ... use_lockfile = true } theo từng môi trường (Part V).
}

provider "aws" { region = "ap-southeast-1" }

variable "name" {
  type    = string
  default = "tf-capstone"
}
variable "db_password" {
  type      = string
  sensitive = true
}

data "aws_availability_zones" "available" { state = "available" }

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

module "network" {
  source   = "./modules/network"
  name     = var.name
  vpc_cidr = "10.0.0.0/16"
  public_subnets = {
    (data.aws_availability_zones.available.names[0]) = cidrsubnet("10.0.0.0/16", 8, 0)
    (data.aws_availability_zones.available.names[1]) = cidrsubnet("10.0.0.0/16", 8, 1)
  }
}

module "web" {
  source     = "./modules/web"
  name       = var.name
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids
  ami_id     = data.aws_ami.al2023.id
}

module "data" {
  source                = "./modules/data"
  name                  = var.name
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.public_subnet_ids
  app_security_group_id = module.web.instance_security_group_id
  db_password_wo        = var.db_password
}

output "alb_dns_name" { value = module.web.alb_dns_name }
output "db_endpoint" { value = module.data.db_endpoint }
output "assets_bucket" { value = module.data.assets_bucket }
