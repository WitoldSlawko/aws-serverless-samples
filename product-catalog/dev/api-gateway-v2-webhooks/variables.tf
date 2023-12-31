locals {
  account_id = "512632984379"
  execution_context        = basename(path.cwd)
  environment   = basename(dirname(path.cwd))
  root_folder = basename(dirname(dirname(path.cwd)))
  repository    = basename(dirname(dirname(dirname(path.cwd))))

  exposed_domain_name = "${local.root_folder}.${var.domain_name}"

  sqs_intergrations = {
    create_product_svc = {
        sqs_arn = data.terraform_remote_state.sqs_lambda_create_product_svc.outputs.sqs_arn
        sqs_url = data.terraform_remote_state.sqs_lambda_create_product_svc.outputs.sqs_url
        rest_method = "POST"
        webhook_path = "create-product"
    }
  }

  lambda_intergrations = {
    get_products_svc = {
        invoke_arn = data.terraform_remote_state.lambda_get_products_svc.outputs.invoke_arn
        lambda_arn = data.terraform_remote_state.lambda_get_products_svc.outputs.lambda_arn
        rest_method = "POST"
        webhook_path = "get-products"
    }
  }
}

variable "domain_name" {
  default = "witold-demo.com"
}
