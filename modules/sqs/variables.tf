variable "prefix_name" {}

variable "environment" {}

variable "fifo_enabled" {
  type = bool
  default = true
}

variable "content_based_deduplication" {
  type = bool
  default = true
}

variable "delay_seconds" {
  type        = number
  default     = 30
}

variable "visibility_timeout_seconds" {
  type        = number
  default     = 180
}

variable "receive_wait_time_seconds" {
  type        = number
  default     = 10
}
