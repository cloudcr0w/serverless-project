# Terraform Modules Overview

This project uses a modular Terraform structure. Below is a list of available modules:

- `apigateway` – sets up API Gateway routes and integration with Lambda.
- `dynamodb` – defines the tasks table.
- `lambda` – deployment package and IAM permissions.
- `s3` – static file hosting for frontend.
- `cloudfront` – CDN distribution with OAI.
- `slack_forwarder` – alerts to Slack using Lambda triggered by SNS.
- `alerting` – SNS topics and CloudWatch metrics.

Each module is loosely coupled and can be reused or modified independently.
