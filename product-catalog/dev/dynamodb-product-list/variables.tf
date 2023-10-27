locals {
  account_id = "512632984379"
  execution_context        = basename(path.cwd)
  environment   = basename(dirname(path.cwd))
  root_folder = basename(dirname(dirname(path.cwd)))
  repository    = basename(dirname(dirname(dirname(path.cwd))))

  dynamodb_table_name = "${local.execution_context}-table"

  attributes_settings = {
    "${var.gsi_name}" = "S"
  }
}

variable "hash_key_name" {
  default = "productName"
}

variable "range_key_name" {
  default = "price"
}

variable "range_key_type" {
  default = "N"
}

variable "gsi_name" {
  default = "productCategory"
}
