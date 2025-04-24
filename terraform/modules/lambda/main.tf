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
resource "aws_lambda_permission" "allow_apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backend_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${module.apigateway.api_execution_arn}/*/*"
}
