variable "api_execution_arn" {
  type = string
}

variable "lambda_role_arn" {
  type = string
}
variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table used by Lambda"
  type        = string
}
variable "stage" {
  type        = string
  description = "Deployment stage (e.g. dev, prod)"
}
