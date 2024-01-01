module "lambda" {
    depends_on = [null_resource.npm_install]
    source = "../../../modules/lambda"
    function_name = "${var.app_name}-lambda"
    zip_file = {
        filename         = "${path.module}/assets/lambda-script.js"
        runtime          = "nodejs16.x"
        handler = "lambda-script.handler"
    }
    env_variables = {
      DYNAMODB_NAME = data.terraform_remote_state.dynamodb.outputs.dynamodb_table_name
    }
    extra_policy_actions = toset(["dynamodb:*"])
}
