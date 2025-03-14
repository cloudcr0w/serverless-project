## Serverless Task Manager 🚀 (Fully Automated Deployment)
A serverless task manager app running entirely on AWS.
Automated CI/CD pipeline using GitHub Actions + Terraform.

### 🌍 Architecture
Frontend: Hosted on Amazon S3, served publicly
Backend: AWS Lambda (Python) + Amazon API Gateway
Database: Amazon DynamoDB for storing tasks
CI/CD: GitHub Actions automating Terraform & deployments
Security: IAM roles with least privilege, S3 encryption


### 🔑 Key Technologies
✅ Terraform – Infrastructure as Code (AWS resources)
✅ GitHub Actions – CI/CD pipeline
✅ AWS IAM – Secure permissions management
✅ Amazon CloudWatch – Logging for Lambda
✅ DynamoDB SSE-KMS – Encryption at rest
✅ S3 Hosting – Static frontend deployment

🛠 How to Deploy (For Devs)
1️⃣ Clone the Repo
```bash

git clone https://github.com/cloudcr0w/serverless-project.git
cd serverless-project
```
2️⃣ Deploy Infrastructure using Terraform
```bash

terraform init
terraform apply -auto-approve
```
3️⃣ Deploy the Frontend
```bash

aws s3 sync . s3://adamwrona-serverless-frontend/ --exclude "terraform/*"
```
4️⃣ Verify API
```bash

curl -X GET https://uij5hsagih.execute-api.us-east-1.amazonaws.com/dev/tasks
```

## 🚀 Continuous Deployment (CI/CD)
🔹 Automatically triggers on every git push to main
🔹 Deploys frontend to S3, updates Lambda, and applies Terraform

🔹 Check the GitHub Actions tab in this repo to see the latest build logs.

## 🎯 Next Steps
🔹 Add monitoring & alerts (e.g., AWS CloudWatch Alarms)
🔹 Implement frontend improvements (better UI, animations)
🔹 Write unit tests & integration tests for Lambda

## 💡 Contributions & Ideas Welcome! 🚀
Fork, PR, or discuss improvements! 🎉