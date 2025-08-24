variable "slack_webhook_url" {
  type        = string
  sensitive   = true
  description = "Slack webhook for alerts"
}
variable "stage" {
  type        = string
  description = "Deployment stage (dev/prod)"
  default     = "dev"
}
variable "tags" {
  type        = map(string)
  description = "Common tags for AWS resources"
  default = {
    Project = "ServerlessTaskManager"
    Owner   = "AdamWrona"
    Env     = "dev"
  }
}
