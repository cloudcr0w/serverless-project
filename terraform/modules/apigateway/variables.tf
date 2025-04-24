variable "lambda_function_arn" {
  description = "ARN of the Lambda function"
  type        = string
}
variable "region" {
  type    = string
  default = "us-east-1"
}
