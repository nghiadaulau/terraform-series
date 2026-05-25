terraform {
  required_version = ">= 1.10"
}

# Đọc state của config "network" (ở đây backend local trỏ tới file state kia).
# Thực tế thường là backend "s3" với cùng bucket/key của tầng network.
data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../network/terraform.tfstate"
  }
}

# Dùng output của tầng network như thể biến của mình.
output "consumed_bucket" {
  value = data.terraform_remote_state.network.outputs.bucket_name
}
