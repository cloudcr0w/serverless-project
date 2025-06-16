# 🛠️ TODO – Serverless Task Manager: Alerting, Terraform Sync & Cleanup

---

## ✅ DONE

- [x] Lambda backend works with simulated `FAIL` (CloudWatch Alarm → SNS → Slack)  
- [x] Slack alerting verified — webhook works, message received  
- [x] GitHub Actions & Terraform plan/apply confirmed functional  
- [x] Lambda ZIPs built and uploaded automatically via GitHub Actions  
- [x] ZIPs ignored via `.gitignore` — clean repo  
- [x] Modules `slack_forwarder` and `alerting` fully managed by Terraform  
- [x] Formatted Slack Message with added emojis

---

## 🔁 NEXT STEPS

### 1. 🎨 Improve Slack Alert Message Formatting ( in progress )

Update `slack_alert_forwarder.py` to parse SNS messages and format them like:

🚨 LambdaErrors-ServerlessBackend-Test entered ALARM state!
Reason: Threshold Crossed: 1 datapoint was greater than the threshold (0.0).


Optional: include function name, severity level emoji, region, timestamp, etc.


### 2. 🧪 Add Unit Tests for Lambda (backend)

✅ `test_lambda_function.py` created with coverage for:

- [x] Valid `POST` request with `title`  
- [x] Missing `title` → should return 400  
- [x] Title = `FAIL` → simulate backend crash / trigger error alarm



### 3. ⚙️ Optional: Add Local Build Script

Although Lambda ZIP is built automatically in CI/CD, a manual helper is still useful:

```bash
# build.sh
zip lambda.zip lambda_function.py
aws s3 cp lambda.zip s3://adamwrona-serverless-frontend/lambda/
```

Optional: Add .env and auto-detect bucket name for multi-env setup.

### 4. 📉 Add Observability: Metrics & Dashboards
 Create CloudWatch dashboard for backend

 Track:

Invocations

Duration

Throttles

Errors

 Optional: Add Grafana integration

### 5. 🔁 Add Rollback Support for Lambda (Optional)
 Enable publish = true for versioned Lambda deploys

 Use aws_lambda_alias to control stable traffic

 Add simple rollback mechanism (manual or Terraform input variable)



🧭 Notes
✅ Slack alert Lambda is now fully Terraform-managed

✅ No manual terraform import required anymore

✅ slack_forwarder and alerting modules are active

✅ terraform apply covers full stack: backend, infra, alerting