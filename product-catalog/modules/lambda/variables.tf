variable "function_name" {}

variable "description" {
  default = null
}

variable "sqs_queue_arn" {
  default = null
}

variable "image_uri" {
  default = null
}

variable "zip_file" {
  type = object({
    filename         = string
    runtime          = string
    handler          = optional(string, "index.handler")
  })
  default = null
}

variable "env_variables" {
  type    = map(string)
  default = {}
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "vpc_id" {
  default = null
}

variable "vpc_cidr" {
  default = null
}

variable "role_custom_policies" {
  type    = list(object({
    actions = list(string)
    resources = optional(list(string))
  }))
  default = []
}

variable "extra_policy_actions" {
  type = set(string)
  default = []
}

variable "memory_size" {
  default = "128"
}

variable "timeout" {
  default = "30"
}

variable "layers" {
  default = []
}

variable "custom_event_source_arn" {
  default = null
}

variable "enable_custom_event_source" {
  type = bool
  default = false
}

variable "logging_retention_in_days" {
  description = "Specifies the number of days you want to retain log events for the lambda log group. Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  type        = number
  default     = 180
}
