resource "aws_dynamodb_table" "dynamodb_table" {
  name           = var.dynamodb_table_name

  read_capacity  = var.billing_mode == "PAY_PER_REQUEST" ? null : var.read_capacity
  write_capacity = var.billing_mode == "PAY_PER_REQUEST" ? null : var.write_capacity

  hash_key       = var.hash_key_name
  range_key = var.range_key_name

  attribute {
    name = var.hash_key_name
    type = var.hash_key_type
  }

  dynamic "attribute" {
    for_each = var.range_key_name != null ? ["set_range_key"] : []
    content {
      name = var.range_key_name
      type = var.range_key_type
    }
  }

  dynamic "attribute" {
    for_each = var.attributes_settings
    content {
      name = attribute.key
      type = attribute.value
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.gsi_name != null ? ["gsi_enabled"] : []
    content {
      name               = "${var.gsi_name}-indexed"
      hash_key           = var.range_key_name
      range_key          = var.gsi_name
      write_capacity     = var.billing_mode == "PAY_PER_REQUEST" ? null : var.write_capacity
      read_capacity      = var.billing_mode == "PAY_PER_REQUEST" ? null : var.read_capacity
      projection_type    = "INCLUDE"
      non_key_attributes = [var.hash_key_name]
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.lsi_name != null ? ["lsi_enabled"] : []
    content {
      name               = "${var.lsi_name}-indexed"
      range_key          = var.lsi_name
      projection_type    = "INCLUDE"
      non_key_attributes = [var.range_key_name]
    }
  }

  dynamic "ttl" {
    for_each = var.enable_ttl ? ["ttl_enabled"] : []
    content {
      attribute_name = var.ttl_name
      enabled        = var.enable_ttl
    }
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = 100
  min_capacity       = 5
  resource_id        = "table/${var.dynamodb_table_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70
  }
}