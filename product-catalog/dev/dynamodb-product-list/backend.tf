
terraform {
  backend "s3" {
    bucket         = "witold-slawko-demo-ks-terraform-backend"
    key            = "poc/product-catalog/dynamodb-product-list/terraform.state"
    region         = "eu-west-1"
    dynamodb_table = "terraform_lock"
  }
}
