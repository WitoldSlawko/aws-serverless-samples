module "sqs_queue" {
  source        = "../../modules/sqs"
  prefix_name = "${var.app_name}-sqs"
  environment   = local.environment
}

module "lambda" {
    depends_on = [null_resource.npm_install]
    source = "../../modules/lambda"
    function_name = "${var.app_name}-lambda"
    zip_file = {
        filename         = "${path.module}/assets/lambda-script.js"
        runtime          = "nodejs16.x"
        handler = "lambda-script.handler"
    }
    env_variables = {
      Environment = local.environment
    }
    extra_policy_actions = toset(["dynamodb:*", "sqs:*"])
    sqs_queue_arn = module.sqs_queue.sqs_arn
}
