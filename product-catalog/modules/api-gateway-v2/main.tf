resource "aws_apigatewayv2_api" "api_gw_v2" {
  name          = "${var.prefix_name}-${var.environment}-api-gw"
  protocol_type = "HTTP"
}

resource "aws_iam_role" "api_gw_role" {
  name ="${var.prefix_name}-${var.environment}-api-gw-role"
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "apigateway.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "webhook_sqs_policy" {
  count = var.sqs_intergrations != {} ? 1 : 0
  name = "${var.prefix_name}-${var.environment}-api-gw-sqs-policy"
  role = aws_iam_role.api_gw_role.name
  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:*",
        ],
        "Resource" : local.sqs_arns != [] ? local.sqs_arns : ["*"]
      }
    ]
  })
}

resource "aws_apigatewayv2_integration" "sqs_integration" {
  for_each = var.sqs_intergrations
  api_id              = aws_apigatewayv2_api.api_gw_v2.id
  credentials_arn     = aws_iam_role.api_gw_role.arn
  integration_type    = "AWS_PROXY"
  integration_subtype = "SQS-SendMessage"
  request_parameters = {
    "QueueUrl"    = each.value["sqs_url"]
    "MessageBody" = "$request.body"
    "MessageDeduplicationId" = join("", tolist(["$request.header.timestamp"]))
    "MessageGroupId" = join("", tolist(["$request.header.timestamp"]))
  }
}

resource "aws_apigatewayv2_route" "sqs_route" {
  for_each = var.sqs_intergrations
  api_id    = aws_apigatewayv2_api.api_gw_v2.id
  route_key = "${each.value["rest_method"]} /${each.value["webhook_path"]}"
  target    = "integrations/${aws_apigatewayv2_integration.sqs_integration[each.key].id}"
}

resource "aws_iam_role_policy" "webhook_lambda_policy" {
  count = var.lambda_intergrations != {} ? 1 : 0
  name = "${var.prefix_name}-${var.environment}-api-gw-lambda-policy"
  role = aws_iam_role.api_gw_role.name
  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:*",
        ],
        "Resource" : local.lambda_arns != [] ? local.lambda_arns : ["*"]
      }
    ]
  })
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  for_each = var.lambda_intergrations
  api_id              = aws_apigatewayv2_api.api_gw_v2.id
  integration_type    = "AWS_PROXY"
  credentials_arn     = aws_iam_role.api_gw_role.arn
  connection_type           = "INTERNET"
   integration_method        = each.value["rest_method"]
  integration_uri = each.value["invoke_arn"]
}

resource "aws_apigatewayv2_route" "lambda_route" {
  for_each = var.lambda_intergrations
  api_id    = aws_apigatewayv2_api.api_gw_v2.id
  route_key = "${each.value["rest_method"]} /${each.value["webhook_path"]}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration[each.key].id}"
}

resource "aws_cloudwatch_log_group" "api_gw_cw_log_group" {
  name              = "/aws/api-gateway/${aws_apigatewayv2_api.api_gw_v2.name}"
  retention_in_days = var.logging_retention_in_days
}

resource "aws_iam_role_policy" "webhook_cw_policy" {
  name = "${var.prefix_name}-${var.environment}-api-gw-cw-policy"
  role = aws_iam_role.api_gw_role.name

  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "${aws_cloudwatch_log_group.api_gw_cw_log_group.arn}*"
        ]
      }
    ]
  })
}

resource "aws_apigatewayv2_stage" "webhook" {
  lifecycle {
    ignore_changes = [
      default_route_settings,
      deployment_id
    ]
  }

  api_id      = aws_apigatewayv2_api.api_gw_v2.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_cw_log_group.arn

    format = jsonencode({
      "requestId"   = "$context.requestId"
      "httpMethod"  = "$context.httpMethod"
      "path"        = "$context.path"
      "protocol"    = "$context.protocol"
      "status"      = "$context.status"
      "requestTime" = "$context.requestTime"
    })
  }
}

resource "aws_apigatewayv2_domain_name" "api_gw_domain" {
  count = var.acm_cert_arn != null ? 1 : 0
  domain_name = var.exposed_domain_name

  domain_name_configuration {
    certificate_arn = var.acm_cert_arn
    endpoint_type   = "regional"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "api_gw_mapping" {
  count = var.acm_cert_arn != null ? 1 : 0
  api_id      = aws_apigatewayv2_api.api_gw_v2.id
  domain_name = aws_apigatewayv2_domain_name.api_gw_domain[0].id
  stage       = aws_apigatewayv2_stage.webhook.id
}
