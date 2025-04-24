
# 🚀 Serverless Task Manager – Fully Serverless, Fully Automated

A lightweight, production-ready task manager app built using 100% AWS managed services.  
Designed for scalability, automation, and zero server maintenance.

🌐 **LIVE DEMO:**  
👉 https://adamwrona-serverless-frontend.s3.amazonaws.com/index.html

---

## 🏗 Architecture Overview

| Layer        | Technology                                   |
|--------------|----------------------------------------------|
| **Frontend** | HTML/CSS/JS (vanilla), hosted on Amazon S3   |
| **API**      | AWS Lambda (Python), exposed via API Gateway |
| **Database** | Amazon DynamoDB                              |
| **CI/CD**    | GitHub Actions + Terraform                   |
| **Security** | IAM roles, CORS handling, HTTPS, encryption  |

---

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

## 🎯 Roadmap / Ideas for Growth

- [ ] Add unit tests and integration tests for Lambda  
- [ ] Add user authentication (Cognito/Auth0)  
- [ ] Auto-alerting with SNS or PagerDuty  
- [ ] Replace vanilla JS with React/Vue (optional)

---

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
