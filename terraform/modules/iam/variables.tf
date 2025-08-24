variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  type        = string
}
variable "tags" {
  type        = map(string)
  description = "Common tags for AWS resources"
}
