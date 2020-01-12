locals {
  generate_keys = var.encryption_enabled ? var.generate_kms_key ? 1 : 0 : 0
}

resource "aws_kms_key" "key" {
  count                   = local.generate_keys
  description             = "Encryption key for MQ broker ${module.label.id}"
  tags                    = module.label.tags
  enable_key_rotation     = true
  deletion_window_in_days = 12
}

resource "aws_kms_alias" "key" {
  count         = local.generate_keys
  name          = "alias/${module.label.id}"
  target_key_id = join("", aws_kms_key.key.*.key_id)
}
