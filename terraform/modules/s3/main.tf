resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
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


resource "aws_s3_bucket_lifecycle_configuration" "frontend_cleanup" {
  bucket = aws_s3_bucket.frontend_bucket.id

  rule {
    id     = "cleanup"
    status = "Enabled"

    filter {
      prefix = "lambda/"
    }

    expiration {
      days = 7
    }
  }
}
