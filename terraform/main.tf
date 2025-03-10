# 1️⃣ Terraform configuration and AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "local" {}  # Using local backend for state management (for now)
}

provider "aws" {
  region = "us-east-1"  # Change to your preferred AWS region
}

# 2️⃣ S3 Bucket for frontend
resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = "adamwrona-serverless-frontend"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# 3️⃣ DynamoDB table for tasks
resource "aws_dynamodb_table" "tasks_table" {
  name         = "serverless-tasks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "task_id"

  attribute {
    name = "task_id"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }
}

# 4️⃣ IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "serverless_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach CloudWatch Logs policy to Lambda role
resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "lambda-logs-policy"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach DynamoDB access policy to Lambda role
resource "aws_iam_policy_attachment" "lambda_dynamodb_attach" {
  name       = "lambda-dynamodb-policy-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}


# Policy for Lambda to access DynamoDB
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "LambdaDynamoDBAccess"
  description = "Allow Lambda to read/write to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["dynamodb:PutItem", "dynamodb:Scan"]
        Resource = aws_dynamodb_table.tasks_table.arn
      }
    ]
  })
}

# 5️⃣ Lambda function
resource "aws_lambda_function" "backend_lambda" {
  function_name = "serverless-backend"
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "lambda.zip"

  source_code_hash = filebase64sha256("lambda.zip")
}

# Allow API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backend_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*"
}

# 6️⃣ API Gateway setup
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "serverless-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST"]
    allow_headers = ["Content-Type"]
  }
}

# API Gateway integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.backend_lambda.invoke_arn
}

# Routes (Now in correct order)
resource "aws_apigatewayv2_route" "hello_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "post_task_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "POST /tasks"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "get_tasks_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /tasks"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Deploy the API Gateway
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "dev"
  auto_deploy = true
}
