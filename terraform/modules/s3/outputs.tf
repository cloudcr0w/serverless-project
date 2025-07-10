output "bucket_id" {
  value = aws_s3_bucket.frontend_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.frontend_bucket.arn
}

output "bucket_domain" {
  value = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
}
