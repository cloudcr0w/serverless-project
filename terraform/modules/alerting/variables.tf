variable "slack_webhook_url" {
  type        = string
  description = "Slack incoming webhook URL"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function to monitor"
}
