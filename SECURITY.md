# 🔐 Security Notes – Serverless Task Manager

This document tracks security-related improvements and future steps for the project.

---

## ✅ Current Security Measures

- Slack webhook secret stored in **AWS Secrets Manager** (managed by Terraform).
- IAM roles modularized in Terraform (separated for Lambda execution, logging, and DynamoDB access).
- CORS configured for all API methods (GET, POST, PUT, DELETE, OPTIONS).
- HTTPS enforced via CloudFront with Origin Access Identity (OAI).

---

## 🛠️ Planned Improvements

- Rotate Slack webhook secret on a regular basis (add rotation policy).
- Review IAM policies for **least privilege** access:
  - Narrow SecretsManager permissions to a single secret.
  - Restrict Lambda execution roles further.
- Explore AWS KMS encryption for sensitive environment variables.
- Consider adding AWS WAF or API Gateway rate limiting for frontend/API protection.

---

## 🧠 Notes

Security is never “done” — it’s an ongoing process - yes, really 🙂
This project serves as a real-world playground to practice **secure-by-default DevOps**.

