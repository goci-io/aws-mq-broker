
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  namespace  = var.namespace
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = merge(map("Region", var.region), var.tags)
}

locals {
  default_ingress_rule = {
    from_port = 443, 
    to_port   = 443, 
    cidr      = coalesce(var.vpc_cidr, "0.0.0.0/0")
  }
}

resource "aws_mq_configuration" "broker" {
  description    = format("Broker configuration for %s", module.label.id)
  name           = module.label.id
  tags           = module.label.tags
  engine_type    = var.engine
  engine_version = var.engine_version
  data           = file(format("%s/broker.xml", path.module))
}

resource "aws_security_group" "broker" {
  name        = module.label.id
  tags        = module.label.tags
  vpc_id      = var.vpc_id
  description = "Security group for the MQ broker ${module.label.id}"

  dynamic "ingress" {
    for_each = length(var.ingress_rules) > 0 ? var.ingress_rules : [local.default_ingress_rule]

    content {
      from_port   = ingress.from_port
      to_port     = ingress.to_port
      cidr_blocks = ingress.cidr
      protocol    = "tcp"
    }
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_mq_broker" "broker" {
  broker_name        = module.label.id
  tags               = module.label.tags
  engine_type        = var.engine
  engine_version     = var.engine_version
  host_instance_type = var.instance_type
  subnet_ids         = var.subnet_ids
  deployment_mode    = var.deployment_mode
  security_groups    = [aws_security_group.broker.id]

  apply_immediately          = false
  publicly_accessible        = false
  auto_minor_version_upgrade = true

  configuration {
    id       = aws_mq_configuration.broker.id
    revision = aws_mq_configuration.broker.latest_revision
  }

  user {
    username = local.decrypted_username
    password = local.decrypted_password
  }

  maintenance_window_start_time {
    day_of_week = "MONDAY"
    time_of_day = "02:00"
    time_zone   = var.time_zone
  }

  logs {
    general = true
    audit   = var.enable_audit_logging
  }

  dynamic "encryption_options" {
    for_each = var.encryption_enabled ? [1] : []

    content {
      kms_key_id        = join("", aws_kms_alias.key.*.arn)
      use_aws_owned_key = var.generate_kms_key ? false : true
    }
  }
}
