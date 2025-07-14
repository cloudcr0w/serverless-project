output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.frontend_cdn.domain_name}"
}
output "api_url" {
  value = module.apigateway.api_url
}
