variable "lambda_role_arn" {
  description = "ARN of IAM role for the Slack forwarder Lambda"
  type        = string
}

variable "lambda_role_name" {
  description = "Name of the IAM role for the Lambda"
  type        = string
}

variable "slack_webhook_url" {
  description = "Slack Webhook URL for sending alerts"
  type        = string
  sensitive   = true
}

variable "sns_topic_arn" {
  description = "ARN of SNS topic that triggers the Lambda"
  type        = string
}