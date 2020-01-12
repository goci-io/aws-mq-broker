
data "aws_ssm_parameter" "username" {
  count = var.ssm_parameter_username == "" ? 0 : 1
  name  = var.ssm_parameter_username
}

data "aws_ssm_parameter" "password" {
  count = var.ssm_parameter_password == "" ? 0 : 1
  name  = var.ssm_parameter_password
}

data "aws_lambda_invocation" "decrypt" {
  count         = var.lambda_encryption_function == "" ? 0 : 1
  function_name = var.lambda_encryption_function
  input         = jsonencode({
    map = {
      username = var.username
      password = var.password
    }
  })
}

locals {
  decrypted_username = join("", coalescelist(
    data.aws_ssm_parameter.username.*.value, 
    data.aws_lambda_invocation.decrypt.*.result_map["username"], 
    [var.username]
  ))

  decrypted_password = join("", coalescelist(
    data.aws_ssm_parameter.password.*.value, 
    data.aws_lambda_invocation.decrypt.*.result_map["password"], 
    [var.password]
  ))
}
