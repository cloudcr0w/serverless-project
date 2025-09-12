resource "aws_iam_policy" "lambda_s3_access" {
  name        = "lambda-s3-access"
  description = "Allow Lambda to get ZIP from S3"
  policy = jsonencode({
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
  function_name    = "slack-alert-forwarder"
  filename         = "${path.module}/lambda/slack_alert_forwarder.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/slack_alert_forwarder.zip")
  handler          = "slack_alert_forwarder.lambda_handler"
  runtime          = "python3.13"
  role             = var.lambda_role_arn
  depends_on       = [null_resource.build_zip]

  lifecycle {
    ignore_changes = [source_code_hash]
  }

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
}
resource "aws_sns_topic_subscription" "sns_to_lambda" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.slack_forwarder.arn
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_forwarder.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}

resource "null_resource" "build_zip" {
  provisioner "local-exec" {
    command     = "cd lambda && zip ../lambda.zip slack_alert_forwarder.py"
    working_dir = path.module
  }
}

