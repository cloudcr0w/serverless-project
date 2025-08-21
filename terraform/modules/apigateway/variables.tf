variable "lambda_function_arn" {
  description = "ARN of the Lambda function"
  type        = string
}
variable "region" {
  type    = string
  default = "us-east-1"
}
# variable "api_id" {
#   description = "HTTP API (v2) ID"
#   type        = string
# }

# variable "integration_id" {
#   description = "Integration ID used to route to Lambda"
#   type        = string
# }
