variable "lambda_function_arn" {
  description = "ARN of the Lambda function"
  type        = string
}
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "stage" {
  type        = string
  description = "Deployment stage (e.g. dev, prod)"
}
variable "tags" {
  type        = map(string)
  description = "Common tags for AWS resources"
}
