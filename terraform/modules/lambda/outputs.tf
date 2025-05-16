
output "lambda_function_arn" {
  value = aws_lambda_function.backend_lambda.arn
}

output "function_name" {
  value = aws_lambda_function.backend_lambda.function_name
}
