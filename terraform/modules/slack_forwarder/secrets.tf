resource "aws_secretsmanager_secret" "slack_webhook" {
  name        = "slack-webhook-url"
  description = "Slack Webhook URL for alert forwarding"
}

resource "aws_secretsmanager_secret_version" "slack_webhook" {
  secret_id     = aws_secretsmanager_secret.slack_webhook.id
  secret_string = var.slack_webhook_url
}
