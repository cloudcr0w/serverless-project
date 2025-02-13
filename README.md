# **Serverless Project** *(Work in Progress)*

A concise serverless web application (e.g., task manager or notes app) built on **AWS** services.

---

## **Architecture**
- **Front End**: Hosted on **Amazon S3**, distributed via **Amazon CloudFront**  
- **Back End**: **AWS Lambda** (Python/Node.js) + **Amazon API Gateway**  
- **Database**: **Amazon DynamoDB** (encrypted at rest with SSE-KMS)  

---

## **Key Technologies**
- **Terraform / AWS CloudFormation** (Infrastructure as Code)  
- **AWS CodePipeline / GitHub Actions / Jenkins** (CI/CD)  
- **AWS IAM** (Least privilege IAM roles)  
- **Encryption**: S3 SSE-KMS, DynamoDB SSE-KMS, TLS for data in transit  
- **Monitoring & Logging**: **Amazon CloudWatch**, **CloudTrail**, **X-Ray**  
- **Security**: **AWS WAF**, **Shield Standard**, **GuardDuty**, **Security Hub**  

---

## **How to Use (Draft)**
1. **Clone** this repo:
   ```bash
   git clone https://github.com/your-username/serverless-project.git
   cd serverless-project
   ```
2. **Deploy Infrastructure**
   Using Terraform:
   ```bash
    terraform init
    terraform plan
    terraform apply
   ```
    Using CloudFormation:
    ```bash
    aws cloudformation deploy \
     --template-file template.yaml \
     --stack-name serverless-stack 
     ```
 
3. **Build & Upload the front-end to your S3 bucket.**
    Verify:
    API Endpoints via API Gateway
    Lambda Logs in CloudWatch
