resource "aws_dynamodb_table" "tasks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }


  server_side_encryption {
    enabled = true
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}
