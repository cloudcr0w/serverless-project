#!/bin/bash

echo "📦 Building Lambda package..."
zip lambda.zip lambda_function.py

echo "☁️ Uploading to S3..."
aws s3 cp lambda.zip s3://adamwrona-serverless-frontend/lambda/

echo "✅ Done."
