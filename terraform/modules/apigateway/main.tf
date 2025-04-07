resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "serverless-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "DELETE"]
    allow_headers = ["Content-Type"]
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_function_arn
}

resource "aws_apigatewayv2_route" "get_tasks_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /tasks"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "dev"
  auto_deploy = true
}
