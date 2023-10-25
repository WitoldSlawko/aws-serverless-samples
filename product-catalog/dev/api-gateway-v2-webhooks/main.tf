module "api_gateway_v2" {
  source        = "../../modules/api-gateway-v2"
  prefix_name = local.execution_context
  environment   = local.environment
  exposed_domain_name = local.exposed_domain_name
  acm_cert_arn = data.aws_acm_certificate.acm_cert.arn

  sqs_intergrations = local.sqs_intergrations
}


module "route53_alias_record" {
  source        = "../../modules/route53-alias-record"
  exposed_domain_name = local.exposed_domain_name
  hosted_zone_id = data.aws_route53_zone.public_hosted_zone.zone_id
  target_domain_name = module.api_gateway_v2.api_gw_target_domain_name
  target_zone_id = module.api_gateway_v2.api_gw_target_zone_id
}