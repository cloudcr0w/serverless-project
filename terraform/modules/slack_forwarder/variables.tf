variable "sns_topic_arn" {
  type = string
  description =  "ARN of the SNS topic to subscribe to"
}

variable "slack_webhook_url" {
  type = string
  description = "Slack webhook for URL alerts"
}