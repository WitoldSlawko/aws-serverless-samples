data "archive_file" "lambda_code" {
  count = var.zip_file != null ? 1 : 0

  type        = "zip"
  source_file = var.zip_file.filename
  output_path = "${path.module}/lambda.zip"
}

data "aws_iam_policy_document" "baseline_policy" {
  statement {
    actions   = setunion(["cloudwatch:*", "ec2:*", "logs:*"], var.extra_policy_actions)
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "merged_policy" {
  count = length(var.role_custom_policies) > 0 ? 1 : 0

  source_policy_documents = [
    data.aws_iam_policy_document.baseline_policy.json,
    data.aws_iam_policy_document.custom_policies[0].json
  ]
}

data "aws_iam_policy_document" "custom_policies" {
  count = length(var.role_custom_policies) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = var.role_custom_policies
    content {
      actions   = statement.value.actions
      resources = coalescelist(statement.value.resources, ["*"])
    }
  }
}