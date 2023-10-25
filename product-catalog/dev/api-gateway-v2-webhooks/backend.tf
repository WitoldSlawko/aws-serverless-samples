
terraform {
  backend "s3" {
    bucket         = "witold-slawko-demo-ks-terraform-backend"
    key            = "poc/product-catalog/api-gateway-v2-webhooks/terraform.state"
    region         = "eu-west-1"
    dynamodb_table = "terraform_lock"
  }
}
