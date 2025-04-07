resource "aws_lambda_function" "backend_lambda" {
  function_name = "serverless-backend"
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"
  role          = var.lambda_role_arn
  filename      = "${path.module}/lambda.zip"

  source_code_hash = filebase64sha256("${path.module}/lambda.zip")


  # lifecycle {
  #   prevent_destroy = true
  # }
  tags = {
    Project     = "Serverless Task Manager"
    Environment = "Dev"
    Owner       = "Adam Wrona"
  }

}
