# 🛠 DEVLOG – Serverless Task Manager

This document tracks key development steps, decisions, and technical improvements made throughout the project.

---

## ✅ Milestone: MVP Complete

- Lambda API created with full CRUD support (POST, GET, DELETE)
- Connected to DynamoDB for persistence
- CORS handled for frontend integration
- API exposed via API Gateway
- Manual test of basic tasks: OK

---

## 🧪 Unit Testing (Pytest)

- Created `test_lambda_function.py` with:
  - ✅ Positive test for valid `POST`
  - ✅ Negative tests for invalid `title` values (None, empty, number)
- Used `@patch` for mocking DynamoDB table (no real AWS calls)
- Test coverage includes:
  - Data validation
  - Response codes
  - JSON structure


## 🧪 Running Tests

Tests are located in `terraform/tests/`, while `lambda_function.py` lives in `terraform/`.

Use `make test` to run tests with the correct module path:

```bash
make test
PYTHONPATH=terraform pytest terraform/tests/
```

---

## 🛡 Input Validation Improvements

- Added checks for missing or empty request body
- Validated that `title` is a non-empty string
- Replaced redundant checks with a single clean condition

---

## 📊 CloudWatch Observability

- CloudWatch Dashboard created via Terraform
- Added widgets:
  - ✅ Invocations
  - ✅ Duration
  - ✅ Errors
  - ✅ Throttles (NEW)

---

## 🧹 Infrastructure Cleanup

- Added `aws_s3_bucket_lifecycle_configuration` to auto-delete old Lambda ZIPs (prefix: `lambda/`, TTL: 7 days)
- Removed deprecated inline `lifecycle_rule`
- Updated `.gitignore` to include `.pytest_cache/`

---

## 🧰 CI/CD Summary

- GitHub Actions build ZIP + deploy Lambda
- Terraform infra changes applied on push
- Frontend manually synced to S3 for now

---

## 🧠 Lessons Learned

- ✅ Mocking AWS in unit tests is essential to avoid costs and speed up dev
- ✅ Handling edge cases early helps prevent 500 errors later
- ✅ Keeping IaC modular (Terraform modules) makes iteration faster

---

### ✍️ Author's Note

This log is part of my real-world DevOps journey.  
I wanted a project that proves:
- I can go from zero to production
- I understand CI/CD, serverless, IaC, alerting, and testing
- I can ship and document properly

Thanks for reading!

— Adam Wrona ☁️🧠
