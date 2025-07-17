#!/bin/bash

# build.sh from root directory of the project

LAMBDA_DIR="terraform//"
ZIP_NAME="lambda.zip"
LAMBDA_FILE="$LAMBDA_DIR/lambda_function.py"

# Sanity checks
command -v zip >/dev/null || { echo "❌ zip not found. Please install it."; exit 1; }
command -v aws >/dev/null || { echo "❌ AWS CLI not found."; exit 1; }
[ -f "$LAMBDA_FILE" ] || { echo "❌ Lambda source file not found at $LAMBDA_FILE"; exit 1; }

echo "🧪 Running tests..."
PYTHONPATH=terraform pytest terraform/tests || exit 1

# Build ZIP
echo "📦 Zipping $LAMBDA_FILE..."
zip "$ZIP_NAME" "$LAMBDA_FILE" > /dev/null

# Upload to S3
echo "☁️ Uploading to S3..."
aws s3 cp "$ZIP_NAME" s3://adamwrona-serverless-frontend/lambda/lambda.zip

echo "✅ Done. Lambda ZIP uploaded."
