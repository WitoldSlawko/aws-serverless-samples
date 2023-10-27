resource "null_resource" "npm_install" {
  triggers = {
    timestamp = "${replace("${timestamp()}", "/[-| |T|Z|:]/", "")}"
  }

  provisioner "local-exec" {
    command = "cd ${path.module}/assets/ && npm install -d && npx tsc lambda-script.ts"
  }
}

data "terraform_remote_state" "dynamodb" {
  backend = "s3"
  config = {
    bucket         = "witold-slawko-demo-ks-terraform-backend"
    key            =  "poc/product-catalog/dynamodb-product-list/terraform.state"
    region         = "eu-west-1"
    dynamodb_table = "terraform_lock"
  }
}