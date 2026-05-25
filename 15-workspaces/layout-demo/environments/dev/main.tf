terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
  # backend "s3" { bucket = "...", key = "dev/app.tfstate", region = "ap-southeast-1" }
}
provider "aws" { region = "ap-southeast-1" }

module "app" {
  source        = "../../modules/app"
  environment   = "dev"
  instance_type = "t3.micro"
}

output "bucket" { value = module.app.bucket }
