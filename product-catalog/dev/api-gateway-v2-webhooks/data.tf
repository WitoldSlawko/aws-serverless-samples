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

data "terraform_remote_state" "sqs_lambda_getproducts_svc" {
  backend = "s3"
  config = {
    bucket         = "witold-slawko-demo-ks-terraform-backend"
    key            = "poc/product-catalog/sqs-lambda-getproducts-svc/terraform.state"
    region         = "eu-west-1"
    dynamodb_table = "terraform_lock"
  }
}