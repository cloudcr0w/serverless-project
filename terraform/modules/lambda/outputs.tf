
output "lambda_function_arn" {
  value = aws_lambda_function.backend_lambda.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.backend_lambda.function_name
}
