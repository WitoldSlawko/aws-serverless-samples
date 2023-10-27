locals {
  account_id = "512632984379"
  execution_context        = basename(path.cwd)
  environment   = basename(dirname(path.cwd))
  root_folder = basename(dirname(dirname(path.cwd)))
  repository    = basename(dirname(dirname(dirname(path.cwd))))
}

variable "app_name" {
  default = "create-product"
}