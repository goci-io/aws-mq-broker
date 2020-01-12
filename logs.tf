
resource "aws_cloudwatch_log_group" "general" {
  name              = format("/aws/amazonmq/broker/%s/general", aws_mq_broker.broker.id) 
  tags              = merge(map("LogType", "General"), module.label.tags)
  kms_key_id        = join("", kms_key_alias.key.*.arn)
  retention_in_days = var.retention_in_days
}

resource "aws_cloudwatch_log_group" "audit" {
  count             = var.enable_audit_logging ? 1 : 0
  name              = format("/aws/amazonmq/broker/%s/audit", aws_mq_broker.broker.id) 
  tags              = merge(map("LogType", "Audit"), module.label.tags)
  kms_key_id        = join("", kms_key_alias.key.*.arn)
  retention_in_days = var.retention_in_days_audit
}

data "aws_iam_policy_document" "log_permission" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = concat(
      [aws_cloudwatch_log_group.general.arn],
      aws_cloudwatch_log_group.audit.*.arn
    )

    principals {
      type        = "Service"
      identifiers = ["mq.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "iam:ResourceTag/Namespace"
      values   = [var.namespace]
    }

    condition {
      test     = "StringEquals"
      variable = "iam:ResourceTag/Stage"
      values   = [var.stage]
    }
  }
}
