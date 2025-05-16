resource "aws_iam_policy" "lambda_s3_access" {
  name        = "lambda-s3-access"
  description = "Allow Lambda to get ZIP from S3"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::adamwrona-serverless-frontend/lambda/slack_alert_forwarder.zip"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access_attachment" {
  role       = var.lambda_role_name
  policy_arn = aws_iam_policy.lambda_s3_access.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = var.lambda_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "slack_forwarder" {
  function_name = "slack-alert-forwarder"
  s3_bucket     = "adamwrona-serverless-frontend"
  s3_key        = "lambda/slack_alert_forwarder.zip"
  publish       = false
  handler       = "slack_alert_forwarder.lambda_handler"
  runtime       = "python3.10"
  role          = var.lambda_role_arn

  lifecycle {
    ignore_changes = [source_code_hash]
  }

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_forwarder.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}