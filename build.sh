#!/bin/bash

# Sanity check
command -v zip >/dev/null || { echo "❌ zip not found. Please install it."; exit 1; }
command -v aws >/dev/null || { echo "❌ AWS CLI not found."; exit 1; }

# Build Lambda deployment package
echo "📦 Zipping lambda_function.py..."
zip lambda.zip lambda_function.py > /dev/null

# Upload to S3
echo "☁️ Uploading to S3... one second please..."
aws s3 cp lambda.zip s3://adamwrona-serverless-frontend/lambda/lambda.zip

echo "✅ Done. Lambda ZIP uploaded."
