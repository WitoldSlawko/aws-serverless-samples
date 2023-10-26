resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  description   = var.description
  role          = aws_iam_role.lambda_role.arn
  memory_size   = var.memory_size
  timeout       = var.timeout
  package_type  = var.image_uri != null ? "Image" : "Zip"

  # image
  image_uri = var.image_uri

  # files
  filename         = data.archive_file.lambda_code[0].output_path
  source_code_hash = data.archive_file.lambda_code[0].output_base64sha256
  handler          = var.zip_file != null ? var.zip_file.handler : null
  runtime          = var.zip_file != null ? var.zip_file.runtime : null

  layers = var.layers

  dynamic "vpc_config" {
    for_each = length(var.subnet_ids) > 0 ? ["it"] : []
    content {
      security_group_ids = [aws_security_group.lambda_sg[0].id]
      subnet_ids         = var.subnet_ids
    }
  }

  dynamic "environment" {
    for_each = var.env_variables != {} ? ["set_env_vars"] : []
    content {
      variables = var.env_variables
    }
  }
}

resource "aws_security_group" "lambda_sg" {
  count  = length(var.subnet_ids) > 0 ? 1 : 0
  name   = "${var.function_name}-sg"
  vpc_id = var.vpc_id
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.function_name}-role"
  assume_role_policy = jsonencode({
    "Version"   = "2012-10-17"
    "Statement" = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "${var.function_name}-policy"
  role   = aws_iam_role.lambda_role.name
  policy = length(var.role_custom_policies) > 0 ? data.aws_iam_policy_document.merged_policy[0].json : data.aws_iam_policy_document.baseline_policy.json
}

resource "aws_cloudwatch_log_group" "cw_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.logging_retention_in_days
}

resource "aws_lambda_function_event_invoke_config" "event_invoke_config" {
  function_name                = aws_lambda_function.lambda.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

resource "aws_lambda_event_source_mapping" "sqs_event_source_mapping" {
  for_each = var.sqs_queues_arns
  event_source_arn  = each.value # var.sqs_queue_arn
  function_name     = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "sqs_invoke_permissions" {
  for_each = var.sqs_queues_arns
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = each.value # var.sqs_queue_arn
}
