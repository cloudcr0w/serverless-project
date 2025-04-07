resource "aws_dynamodb_table" "tasks_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "task_id"

  attribute {
    name = "task_id"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}
