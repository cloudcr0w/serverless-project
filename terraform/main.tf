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

# 2️⃣ Create an S3 bucket for hosting the frontend
resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = "adamwrona-serverless-frontend"
  force_destroy = true  # Allows deletion of the bucket and its contents (useful for testing)
}

# 3️⃣ Configure S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# 4️⃣ Enable versioning for S3 bucket (optional)
resource "aws_s3_bucket_versioning" "frontend_versioning" {
  bucket = aws_s3_bucket.frontend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 5️⃣ Create a DynamoDB table for the application
resource "aws_dynamodb_table" "app_table" {
  name         = "serverless-app-table"
  billing_mode = "PAY_PER_REQUEST"  # Auto-scaling pricing model
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  # AWS automatically encrypts DynamoDB at rest, so we don't specify a KMS key
}

# 6️⃣ Create an IAM role for AWS Lambda
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

# 7️⃣ Attach a policy to allow Lambda to write logs to CloudWatch
resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "lambda-logs-policy"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#  Create an AWS Lambda function
resource "aws_lambda_function" "backend_lambda" {
  function_name    = "serverless-backend"
  runtime         = "python3.9"  # Change to "nodejs18.x" if using Node.js
  handler         = "lambda_function.lambda_handler"
  role            = aws_iam_role.lambda_role.arn
  filename        = "lambda.zip"

  source_code_hash = filebase64sha256("lambda.zip")
}

# API Gateway setup
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "serverless-api"
  protocol_type = "HTTP"
}

#  Create API Gateway integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.backend_lambda.invoke_arn
}

#  Define a route for API Gateway (e.g., GET /hello)
resource "aws_apigatewayv2_route" "hello_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

#  Deploy the API Gateway
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "dev"
  auto_deploy = true
}
