resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  # lifecycle {
  #   prevent_destroy = true
  # }
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
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })
}
module "apigateway" {
  source = "./modules/apigateway"
  lambda_function_arn = module.lambda.lambda_arn
}

module "lambda" {
  source = "./modules/lambda"
  apigateway = module.apigateway
}
