resource "aws_route53_record" "r53_alias_record" {
  name    = var.exposed_domain_name
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    name                   = var.target_domain_name
    zone_id                = var.target_zone_id
    evaluate_target_health = false
  }
}