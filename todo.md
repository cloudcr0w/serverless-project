# 🛠️ TODO – Serverless Task Manager: Alerting, Terraform Sync & Cleanup

---

## ✅ DONE

- [x] Lambda backend works with simulated `FAIL` (`CloudWatch Alarm → SNS → Slack`)
- [x] Slack alerting verified — webhook functional, messages received
- [x] GitHub Actions: Terraform plan/apply + Lambda ZIP build & upload
- [x] `.gitignore` updated — ZIPs ignored for clean repo
- [x] Modules `slack_forwarder` & `alerting` fully managed by Terraform
- [x] Formatted Slack messages with emojis
- [x] Unit tests for Lambda (`test_lambda_function.py`) running via GitHub Actions:
  - Valid `POST` with `title`
  - Missing `title` → returns 400
  - Title = `FAIL` → simulates crash
- [x] Created CloudWatch Dashboard tracking:
  - Lambda Invocations
  - Duration

---

## 🛠️ IN PROGRESS

### 1. 🎨 Improve Slack Alert Formatting

Goal: Make alerts more readable and informative, e.g.:

🚨 LambdaErrors-ServerlessBackend-Test entered ALARM state!
Reason: Threshold Crossed: 1 datapoint was greater than the threshold (0.0).


**Extras:** function name, severity emoji, region, timestamp, etc.

---

## 🔁 NEXT STEPS

### 2. 📊 Add More CloudWatch Metrics

- [x] Added `Errors` (included in main widget)
- [x] Added `Invocations` and `Duration` (dashboard ready)
- [x] Add Lambda `Throttles`
- [ ] (Optional) Grafana integration via CloudWatch datasource


---

### 3. 🧪 Expand Unit Testing

- [x] Add test for `GET` handler
- [ ] Add test for `DELETE` handler
- [ ] Add test coverage for CloudWatch alert handler (Slack forwarder)

---

### 4. 🔃 Add Manual Lambda Build Helper (DONE)

Added `build.sh` script with ZIP + S3 upload  
Includes CLI checks for `zip` and `aws`

```bash
# build.sh
zip lambda.zip lambda_function.py
aws s3 cp lambda.zip s3://adamwrona-serverless-frontend/lambda/
```

Extras: .env support, auto bucket detection, multi-env paths

### 5. 🛡️ Add Rollback Support for Lambda (Optional)
 Enable publish = true for versioned deploys

 Use aws_lambda_alias to control traffic routing

 Create manual rollback path or Terraform toggle input

 ### 6. 📦 Use environment variables for config (Optional)

- [ ] Read table name and region from environment variables instead of hardcoding
- [ ] Add fallback or error if env is missing


🧭 NOTES
✅ Slack alert Lambda is now fully Terraform-managed

✅ No terraform import needed — everything IaC from scratch

✅ terraform apply deploys full stack: backend + observability + alerting