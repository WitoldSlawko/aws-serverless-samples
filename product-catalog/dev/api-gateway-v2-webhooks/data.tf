data "aws_acm_certificate" "acm_cert" {
  domain      = "*.${var.domain_name}"
  statuses    = ["ISSUED"]
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "public_hosted_zone" {
  name         = "${var.domain_name}."
  private_zone = false
}

data "terraform_remote_state" "sqs_lambda_create_product_svc" {
  backend = "s3"
  config = {
    bucket         = "witold-slawko-demo-ks-terraform-backend"
    key            = "poc/product-catalog/sqs-lambda-create-product-svc/terraform.state"
    region         = "eu-west-1"
    dynamodb_table = "terraform_lock"
  }
}

data "terraform_remote_state" "lambda_get_products_svc" {
  backend = "s3"
  config = {
    bucket         = "witold-slawko-demo-ks-terraform-backend"
    key            = "poc/product-catalog/lambda-get-products-svc/terraform.state"
    region         = "eu-west-1"
    dynamodb_table = "terraform_lock"
  }
}