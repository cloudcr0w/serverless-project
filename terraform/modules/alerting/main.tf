resource "aws_sns_topic" "lambda_alerts" {
  name = "serverless-task-alerts"
}

# resource "aws_sns_topic_subscription" "slack_webhook" {
#   topic_arn = aws_sns_topic.lambda_alerts.arn
#   protocol = "https"
#   endpoint = var.slack_webhook_url
# }

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
    alarm_name          = "LambdaErrors-ServerlessTask"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when Lambda function has >1 error"
  alarm_actions       = [aws_sns_topic.lambda_alerts.arn]

  dimensions = {
    FunctionName = var.lambda_function_name
  }
}
