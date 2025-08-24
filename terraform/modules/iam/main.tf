resource "aws_iam_role" "lambda_exec" {
  name = "serverless-lambda-exec"
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}



resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "LambdaDynamoDBAccess"
  description = "Allow Lambda to read/write/delete to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["dynamodb:PutItem", "dynamodb:Scan", "dynamodb:DeleteItem"]
        Resource = var.dynamodb_table_arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_dynamodb_attach" {
  name       = "lambda-dynamodb-policy-attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "lambda-logs-policy-attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
