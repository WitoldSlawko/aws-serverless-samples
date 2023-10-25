resource "aws_dynamodb_table" "dynamodb_table" {
  name           = var.dynamodb_table_name

  read_capacity  = var.billing_mode == "PAY_PER_REQUEST" ? null : var.read_capacity
  write_capacity = var.billing_mode == "PAY_PER_REQUEST" ? null : var.write_capacity

  hash_key       = var.hash_key_name
  range_key = var.range_key_name

  attribute {
    name = var.hash_key_name
    type = var.hash_key_type
  }

  dynamic "attribute" {
    for_each = var.range_key_name != null ? ["set_range_key"] : []
    content {
      name = var.range_key_name
      type = var.range_key_type
    }
  }

  dynamic "attribute" {
    for_each = var.attributes_settings
    content {
      name = attribute.key
      type = attribute.value
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.gsi_name != null ? ["gsi_enabled"] : []
    content {
      name               = "${var.gsi_name}-indexed"
      hash_key           = var.range_key_name
      range_key          = var.gsi_name
      write_capacity     = var.billing_mode == "PAY_PER_REQUEST" ? null : var.write_capacity
      read_capacity      = var.billing_mode == "PAY_PER_REQUEST" ? null : var.read_capacity
      projection_type    = "INCLUDE"
      non_key_attributes = setunion([var.hash_key_name], setsubtract(toset(keys(var.attributes_settings)), toset([var.gsi_name])))
    }
  }

  dynamic "ttl" {
    for_each = var.enable_ttl ? ["ttl_enabled"] : []
    content {
      attribute_name = var.ttl_name
      enabled        = var.enable_ttl
    }
  }
}
