locals {
    sqs_arns = tolist(values({ for sqs in var.sqs_intergrations : sqs.webhook_path => sqs.sqs_arn}))
    lambda_arns = tolist(values({ for lambda in var.lambda_intergrations : lambda.webhook_path => lambda.lambda_arn}))
}

variable "prefix_name" {}

variable "environment" {}

variable "exposed_domain_name" {}

variable "sqs_intergrations" {
    type = map(object({
        sqs_arn = string
        sqs_url = string
        rest_method = string
        webhook_path = string
    }))
    default = {}
}

variable "lambda_intergrations" {
    type = map(object({
        lambda_arn = string
        invoke_arn = string
        rest_method = string
        webhook_path = string
    }))
    default = {}
}

variable "acm_cert_arn" {
    default = null
}

variable "logging_retention_in_days" {
  type        = number
  default     = 7
}