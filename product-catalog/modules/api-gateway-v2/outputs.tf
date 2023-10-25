output "api_endpoint" {
    value = aws_apigatewayv2_api.api_gw_v2.api_endpoint
}

output "api_gw_arn" {
  value = aws_apigatewayv2_api.api_gw_v2.execution_arn
}

output "api_gw_target_domain_name" {
  value = aws_apigatewayv2_domain_name.api_gw_domain[0].domain_name_configuration[0].target_domain_name
}

output "api_gw_target_zone_id" {
  value = aws_apigatewayv2_domain_name.api_gw_domain[0].domain_name_configuration[0].hosted_zone_id
}