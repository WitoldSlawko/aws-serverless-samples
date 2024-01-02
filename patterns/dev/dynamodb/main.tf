module "dynamodb_shop_store" {
  source = "../../../modules/dynamodb-table"

  dynamodb_table_name = "ShopStore"
  hash_key_name = "Id"
  hash_key_type = "N"
  range_key_name = "Title"
  gsi_name = "ProductCategory"
  lsi_name = "Price"
  attributes_settings = {
    "Price" = "N"
    "ProductCategory" = "S"
  }
}
