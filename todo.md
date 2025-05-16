# 🛠️ TODO – Serverless Task Manager: Alerting, Terraform Sync & Cleanup

## ✅ DONE

- [x] Lambda backend works with simulated `FAIL` (CloudWatch Alarm → SNS → Slack)
- [x] Slack alerting verified — webhook works, message received
- [x] GitHub Actions & Terraform plan/apply confirmed functional
- [x] ZIPs ignored via `.gitignore` — clean repo

---

## 🔁 NEXT STEPS

### 1. 🔄 Terraform Import (for manually created resources)

Before running the commands below, **uncomment the `slack_forwarder` and `alerting` modules in `terraform/main.tf`**.

Then run:

```bash
terraform import aws_lambda_function.slack_forwarder slack-alert-forwarder
terraform import aws_sns_topic.lambda_alerts serverless-task-alerts
terraform import aws_cloudwatch_metric_alarm.lambda_error_alarm LambdaErrors-ServerlessBackend-Test
```

### 2. 🎨 Improve Slack Alert Message Formatting
Update slack_alert_forwarder.py to parse and format the SNS message cleanly:

Example:
```bash
🚨 LambdaErrors-ServerlessBackend-Test entered ALARM state!
Reason: Threshold Crossed: 1 datapoint was greater than the threshold (0.0).
```

### 3. 🧪 Add Unit Tests for Lambda (backend)
 Create test_lambda_function.py

 Cover:

valid POST

missing title

title = FAIL triggers exception

### 4. ⚙️ Automate Lambda ZIP Build (optional)
 Add build.sh or Makefile to zip functions before terraform apply

 In GitHub Actions:
```bash
- name: Build Lambda ZIP
  run: zip lambda.zip lambda_function.py
  ```

###  🧭 Notes
slack_forwarder and alerting modules are currently commented out

terraform apply only affects backend (safe)

Slack alert Lambda currently deployed manually (e.g. via S3 upload)