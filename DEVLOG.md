# 🛠 DEVLOG – Serverless Task Manager

This document tracks key development steps, decisions, and technical improvements made throughout the project.

---

## ✅ Milestone: Full CI/CD Redeploy in us-east-1 & Infra Cleanup

- Migrated full infrastructure to `us-east-1` to align with S3 backend region
- Fixed `DynamoDB: Table already exists` error by cleaning up old state
- Replaced broken IAM references (`lambda_role` → `lambda_exec`)
- Standardized all Terraform modules: IAM, API Gateway, Lambda, S3, SNS
- Confirmed full REST functionality:
  - `GET`, `POST`, `PUT`, `DELETE` all working via API Gateway → Lambda → DynamoDB
- Added `PUT` handler for toggling task completion (CORS updated accordingly)
- Lambda ZIP now includes `utils.py` and is built automatically in GitHub Actions
- CI/CD pipeline fully operational:
  - ✅ Lint (`eslint`)
  - ✅ Unit tests (`pytest`)
  - ✅ Lambda build (ZIP + S3 upload)
  - ✅ Terraform `plan` and `apply`
  - ✅ Frontend auto-synced to S3
- Verified alerting workflow works:
  - `Lambda Error` → `SNS` → `Slack` (Webhook)
- Observability via CloudWatch Dashboard (invocations, errors, throttles, duration)

✅ This release is production-grade and showcases end-to-end DevOps skills across IaC, serverless, monitoring, testing, and CI/CD.

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

## ✅ Automation

- Added `Makefile` for `make test`, `make lint`, `make zip`
- Coverage enabled with `pytest-cov`
- Local test run: `make test`

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
