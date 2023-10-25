output "lambda_sg_id" {
  value = length(var.subnet_ids) > 0 ? aws_security_group.lambda_sg[0].id : null
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "lambda_name" {
  value = var.function_name
}