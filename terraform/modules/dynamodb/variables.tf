variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}
output "dynamodb_table_arn" {
  description = "ARN of the created DynamoDB table"
  value       = aws_dynamodb_table.tasks.arn
}
