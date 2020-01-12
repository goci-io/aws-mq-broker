# aws-mq-broker

**Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)**

This module creates an [AWS MQ Broker](https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/welcome.html) and additional security group and optionally a customer managed KMS key. You can also manage the users who can authenticate to the broker with using module. Currently only the `ActiveMQ` engine is supported.

Encrypted user details can be sourced from AWS SSM parameter or using a lambda invocation to decrypt the values on the fly. 
You can deploy an encryption and decrypton lambda using [aws-lambda-kms-encryption](https://github.com/goci-io/aws-lambda-kms-encryption) module.

### Usage

```hcl
module "broker" {
  source                     = "git::https://github.com/goci-io/aws-mq-broker.git?ref=tags/<latest-version>"
  namespace                  = "goci"
  stage                      = "staging"
  region                     = "eu1"
  generate_kms_key           = true
  broker_config_file         = "local broker spec file name"
  lambda_encryption_function = "goci-staging-encryption-decrypt"

  additional_users = [
    {
      groups         = ["apps"]
      username       = "encrypted username"
      password       = "encrypted password"
      console_access = "no-console-access|console-access"
    }
  ]
  ...
}
```
