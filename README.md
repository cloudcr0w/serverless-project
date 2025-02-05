# serverless-project
**Objective: To develop a simple serverless web app - e.g. an application for task management (task manager) or for storing notes.**
Components:

#Front-end:# hosted on Amazon S3 + distributed via Amazon CloudFront.
#Back-end:# written in Python/Node.js and run in AWS Lambda.
#Database:# Amazon DynamoDB (NoSQL).
#Infrastructure as code (IaC):# Terraform or AWS CloudFormation.
#CI/CD:# AWS CodePipeline / GitHub Actions / Jenkins (still thinking which one I choose).
#Monitoring and logging:# Amazon CloudWatch (metrics, logs) + Amazon X-Ray (tracing), AWS CloudTrail (logs of account-level operations).
#Security:# IAM (minimum privilege principle), data encryption in S3 and DynamoDB, possibly pipeline vulnerability scanning.

**Also practices I would be focused on:**
Always HTTPS (ACM + CloudFront + TLS).
IAM: role per Lambda, no redundant permissions.
Encryption: S3 (SSE-KMS), DynamoDB (SSE-KMS), data in transit (TLS).
Logging and auditing: CloudTrail, CloudWatch Logs, GuardDuty, Config.
Network segmentation (if using VPC): private subnets, security groups, NACL (for more advanced scenarios).
Frequent verification: vulnerability scanning tools in pipeline and Security Hub.
WAF + Shield (Standard) for DDoS protection and application attacks.

