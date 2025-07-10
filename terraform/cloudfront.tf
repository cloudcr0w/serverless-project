resource "aws_cloudfront_origin_access_identity" "frontend_oai" {
  comment = "OAI for accessing private S3 bucket"
}

resource "aws_cloudfront_distribution" "frontend_cdn" {
  origin {
    domain_name = module.s3.bucket_domain
    origin_id   = "s3-frontend-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-frontend-origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "ServerlessFrontendCDN"
  }
}

resource "aws_s3_bucket_policy" "frontend_secure_policy" {
  bucket = module.s3.bucket_id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipalReadOnly",
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
        },
        Action   = ["s3:GetObject"],
        Resource = "${module.s3.bucket_arn}/*"
      }
    ]
  })
}
