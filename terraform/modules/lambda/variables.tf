variable "lambda_role_arn" {
  description = "IAM Role ARN for Lambda"
  type        = string
}
variable "apigateway" {
  type = any
}
