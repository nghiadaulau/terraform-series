variable "name_prefix" {
  type        = string
  description = "Tiền tố tên bucket (AWS thêm hậu tố ngẫu nhiên)"
}

variable "versioning" {
  type        = bool
  description = "Bật versioning hay không"
  default     = true
}

variable "force_destroy" {
  type        = bool
  description = "Cho phép xóa bucket kèm object (lab)"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tag gắn cho bucket"
  default     = {}
}
