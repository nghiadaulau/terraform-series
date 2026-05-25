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

# --- Module từ Terraform Registry, PIN phiên bản ---
# Nguồn dạng <namespace>/<name>/<provider>. Luôn pin version để tái lập.
module "registry_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "tf-series-bai13-reg-"
  force_destroy = true
}

# --- COMPOSITION: output của module này -> input của module kia ---
module "data" {
  source        = "./modules/secure-bucket"
  name_prefix   = "tf-series-bai13-data-"
  force_destroy = true
}

module "seed" {
  source    = "./modules/seed-object"
  bucket_id = module.data.id # nối module.data -> module.seed
}

output "registry_bucket_arn" {
  value = module.registry_bucket.s3_bucket_arn
}

output "data_bucket" {
  value = module.data.id
}
