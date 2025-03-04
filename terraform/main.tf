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
