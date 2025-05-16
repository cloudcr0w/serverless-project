resource "aws_iam_role" "lambda_role" {
  name = "slack-forwarder-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "slack_forwarder" {
  function_name = "slack-alert-forwarder"
  filename      = "${path.module}/lambda/slack_alert_forwarder.zip"
  handler       = "slack_alert_forwarder.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_role.arn
#   source_code_hash = filebase64sha256("${path.module}/lambda/slack_alert_forwarder.zip")
    lifecycle {
        ignore_changes = [source_code_hash]
    }

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
}

# resource "aws_lambda_permission" "allow_sns" {
#   statement_id  = "AllowExecutionFromSNS"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.slack_forwarder.function_name
#   principal     = "sns.amazonaws.com"
#   source_arn    = var.sns_topic_arn
# }

# resource "aws_sns_topic_subscription" "sns_to_lambda" {
#   topic_arn = var.sns_topic_arn
#   protocol  = "lambda"
#   endpoint  = aws_lambda_function.slack_forwarder.arn
# }
