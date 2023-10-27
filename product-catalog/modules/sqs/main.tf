resource "aws_sqs_queue" "sqs_queue" {
  name                        = "${var.prefix_name}-${var.environment}${var.fifo_enabled ? ".fifo" : ""}"
  delay_seconds               = var.delay_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  fifo_queue                  = var.fifo_enabled # true
  receive_wait_time_seconds   = var.receive_wait_time_seconds #10
  content_based_deduplication = var.content_based_deduplication # true
}
