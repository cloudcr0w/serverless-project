resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "serverless-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE"]
    allow_headers = ["Content-Type"]
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "get_tasks_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /tasks"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
resource "aws_apigatewayv2_route" "post_tasks_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "POST /tasks"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "delete_task_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "DELETE /tasks/{task_id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "dev"
  auto_deploy = true
}

resource "aws_apigatewayv2_route" "put_task_status_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "PUT /tasks/{task_id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}