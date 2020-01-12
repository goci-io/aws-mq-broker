
variable "stage" {
  type        = string
  description = "The stage the cluster will be deployed for"
}

variable "namespace" {
  type        = string
  description = "Namespace the cluster belongs to"
}

variable "attributes" {
  type        = list
  default     = []
  description = "Additional attributes (e.g. `eu1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "region" {
  type        = string
  description = "The own region identifier for this deployment"
}

variable "engine" {
  type        = string
  default     = "ActiveMQ"
  description = "The engine type to use https://docs.aws.amazon.com/amazon-mq/latest/api-reference/broker-engine-types.html"
}

variable "engine_version" {
  type        = string
  default     = "5.15.0"
  description = "The version of the engine to use"
}

variable "instance_type" {
  type        = string
  default     = "mq.t2.micro"
  description = "AWS Instance type to use for the broker"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "VPC ID for the security group and the MQ broker instance"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnets to place the broker instance in"
}

variable "vpc_cidr" {
  type        = string
  default     = ""
  description = "VPC CIDR to allow traffic to the broker from. Can be omitted if publicly accessible or specific ingress_rules are present"
}

variable "ingress_rules" {
  type        = list(object({
    from_port = number,
    to_port   = number,
    cidr      = string
  }))
  default     = []
  description = "Security ingress rules. Defaults to allow from vpc cidr if set, otherwise 0.0.0.0"
}

variable "deployment_mode" {
  type        = string
  default     = "ACTIVE_STANDBY_MULTI_AZ"
  description = "Use a standby instance for the broker (different AZ. Requires at least 2 subnets). Alternative: SINGLE_INSTANCE"
}

variable "broker_config_file" {
  type        = string
  default     = "activemq-broker.example.xml"
  description = "Config file path relative to the current module directory"
}

variable "encryption_enabled" {
  type        = bool
  default     = true
  description = "Enables encryption for the MQ broker"
}

variable "generate_kms_key" {
  type        = bool
  default     = false
  description = "Generates a custom KMS key. Uses the AWS provided one if false"
}

variable "time_zone" {
  type        = string
  default     = "UTC"
  description = "The timezone for maintenance windows etc"
}

variable "enable_audit_logging" {
  type        = bool
  default     = false
  description = "Enables audit logging on the broker (user actions etc)"
}

variable "retention_in_days_audit" {
  type        = number
  default     = 90
  description = "Retention time in days to keep the audit logs"
}

variable "retention_in_days" {
  type        = number
  default     = 30
  description = "Retention time in days to keep the general logs"
}

variable "ssm_parameter_username" {
  type        = string
  default     = ""
  description = "SSM Parameter name to read the admin username from"
}

variable "ssm_parameter_password" {
  type        = string
  default     = ""
  description = "SSM Parameter name to read the admin password from"
}

variable "username" {
  type        = string
  default     = ""
  description = "Username to use for the administrator"
}

variable "password" {
  type        = string
  default     = ""
  description = "Password to use for the administrator"
}

variable "lambda_encryption_function" {
  type        = string
  default     = ""
  description = "Lambda function name which accepts json in the structure {map:{key: value}} and returns the decrypted values for username and password"
}

variable "additional_users" {
  type        = map(string, map)
  default     = {}
  description = "Additional users to add to the broker. Key is the username and contains console_access, groups and username, password"
}
