
terraform {
  backend "s3" {
    bucket         = "witold-slawko-demo-ks-terraform-backend"
    key            = "poc/product-catalog/lambda-get-products-svc/terraform.state"
    region         = "eu-west-1"
    dynamodb_table = "terraform_lock"
  }
}
