variable "dynamodb_table_name" {}

variable "hash_key_name" {}

variable "range_key_name" {}

variable "gsi_name" {}

variable "billing_mode" {
    default = "PROVISIONED"
}

variable "attributes_settings" {
    type = map(string)
    default = {}
}

variable "hash_key_type" {
    default = "S"
}

variable "range_key_type" {
    default = "S"
}

variable "read_capacity" {
    type = number
    default = 10
}

variable "write_capacity" {
    type = number
    default = 10
}

variable "ttl_name" {
    default = "TimeToExist"
}

variable "enable_ttl" {
    type = bool
    default = false
}
