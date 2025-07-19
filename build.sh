#!/bin/bash

# 📦 build.sh - Build and upload Lambda ZIP package for Serverless Task Manager
# Run from the root directory of the project

set -e  # Stop on error

START_TIME=$(date +%s)

LAMBDA_DIR="terraform/"
LAMBDA_FILE="$LAMBDA_DIR/lambda_function.py"
ZIP_NAME="lambda.zip"
ZIP_PATH="./$ZIP_NAME"
S3_BUCKET="adamwrona-serverless-frontend"
S3_KEY="lambda/lambda.zip"

# === Functions ===
print_header() {
  echo "--------------------------------------------------"
  echo "📦 Serverless Lambda Build Script"
  echo "--------------------------------------------------"
}

fail_if_missing() {
  [ -f "$1" ] || { echo "❌ Required file not found: $1"; exit 1; }
}

# === Script ===
print_header

command -v zip >/dev/null || { echo "❌ zip not found. Please install it."; exit 1; }
command -v aws >/dev/null || { echo "❌ AWS CLI not found."; exit 1; }

fail_if_missing "$LAMBDA_FILE"

echo "🧪 Running unit tests..."
PYTHONPATH=terraform pytest terraform/tests || { echo "❌ Tests failed."; exit 1; }

echo "📦 Zipping Lambda source..."
zip "$ZIP_NAME" "$LAMBDA_FILE" > /dev/null || { echo "❌ Failed to create ZIP."; exit 1; }

echo "☁️ Uploading $ZIP_NAME to s3://$S3_BUCKET/$S3_KEY ..."
aws s3 cp "$ZIP_PATH" "s3://$S3_BUCKET/$S3_KEY" || { echo "❌ Upload failed."; exit 1; }

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "✅ Done in ${DURATION}s. Lambda ZIP uploaded successfully!"