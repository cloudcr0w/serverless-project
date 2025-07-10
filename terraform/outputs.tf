output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.frontend_cdn.domain_name}"
}
