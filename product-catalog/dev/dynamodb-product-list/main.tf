module "dynamodb_product_list" {
  source = "../../modules/dynamodb-table"

  dynamodb_table_name = local.dynamodb_table_name
  hash_key_name = var.hash_key_name
  range_key_name = var.range_key_name
  range_key_type = var.range_key_type
  gsi_name = var.gsi_name
  attributes_settings = local.attributes_settings
}
