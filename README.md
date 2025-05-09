
# ⚙️ Serverless Task Manager – Production-Ready Template for DevOps & Platform Teams

A lightweight, production-ready task manager app built using 100% AWS managed services.  
Designed for scalability, automation, and zero server maintenance.

🌐 **LIVE DEMO:**  
👉 https://adamwrona-serverless-frontend.s3.amazonaws.com/index.html

---

## 🏗 Architecture Overview

![Serverless Architecture](./diagram.png)

| Layer        | Technology                                   |
|--------------|----------------------------------------------|
| **Frontend** | HTML/CSS/JS (vanilla), hosted on Amazon S3   |
| **API**      | AWS Lambda (Python), exposed via API Gateway |
| **Database** | Amazon DynamoDB                              |
| **CI/CD**    | GitHub Actions + Terraform                   |
| **Security** | IAM roles, CORS handling, HTTPS, encryption  |


---
## 💻 Developer Experience & CI/CD

This app is designed as a starter template for cloud-native teams:

- **Zero setup required** – `terraform apply` spins up everything
- **Git-based CI/CD** – just push to `main`, and the app is deployed
- **Fast local development** – frontend can be served locally while API is live on AWS
- **Logs in CloudWatch**, monitoring ready, secure out of the box

Use this project to quickly prototype, train new DevOps engineers, or bootstrap internal tools.

## 🔑 Key Features

✅ Fully serverless: no EC2, no manual servers  
✅ Infrastructure as Code with Terraform  
✅ End-to-end CI/CD pipeline via GitHub Actions  
✅ Secure by default (IAM, CORS, HTTPS, encryption)  
✅ Logs + monitoring ready via Amazon CloudWatch

---

## 🛠 Deployment Guide

**1️⃣ Clone & Configure**

```bash
git clone https://github.com/cloudcr0w/serverless-project.git
cd serverless-project
```

**2️⃣ Provision AWS Infrastructure**

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

**3️⃣ Deploy Frontend**

```bash
aws s3 sync . s3://adamwrona-serverless-frontend --delete
```

**4️⃣ Verify API Health**

```bash
curl https://<your-api-id>.execute-api.us-east-1.amazonaws.com/dev/tasks
```

---

## 🔁 CI/CD Workflow

✅ Triggered on every `git push` to `main`  
✅ Runs Terraform to sync infrastructure  
✅ Updates Lambda code automatically  
✅ Deploys frontend to S3  
✅ Logs available in GitHub Actions tab

---

## 📈 Roadmap – DevOps & Platform Expansion

- [ ] Add unit & integration tests for Lambda functions
- [ ] Add alerting (SNS, Slack, PagerDuty)
- [ ] Add rollback support via versioned Lambda deployment
- [ ] Add metrics dashboard (CloudWatch, Grafana, etc.)
- [ ] Replace vanilla JS with React/Vue (optional)

Bonus:
- [ ] Package as a GitHub template repo
- [ ] Add environment support (dev/staging/prod via workspaces)


## 🧪 Tech Stack Summary

| Layer       | Service / Tool                  |
|-------------|----------------------------------|
| Frontend    | HTML/CSS/JS on Amazon S3        |
| API         | AWS Lambda (Python)             |
| API Gateway | HTTP + CORS + HTTPS             |
| Database    | Amazon DynamoDB                 |
| Infra as Code | Terraform                      |
| CI/CD       | GitHub Actions                  |
| Logging     | Amazon CloudWatch               |
| Security    | IAM, encryption, scoped roles   |


## 👨‍💻 About the Author

This project was created by **Adam Wrona** as part of his DevOps and cloud engineering journey 🚀  
I'm open to feedback, contributions, and collaboration — feel free to fork or reach out!

---

```md
“Sometimes the bug isn't in the code... it's in your expectations.”
— Deep Wisdom, 

„Czasem błąd nie leży w kodzie… tylko w twoich oczekiwaniach.”
— Głęboka mądrość 
```

## 💡 Like this project?

⭐ Star it on GitHub  
🍴 Fork it  
🧠 Share your ideas in Issues/Discussions
