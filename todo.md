# 🛠️ TODO – Serverless Task Manager: Alerting, Terraform Sync & Cleanup

---

## ✅ DONE

- ✅ Lambda backend works with simulated `FAIL` (`CloudWatch Alarm → SNS → Slack`)
- ✅ Slack alerting verified — webhook functional, messages received
- ✅ GitHub Actions: Terraform plan/apply + Lambda ZIP build & upload
- ✅ `.gitignore` updated — ZIPs ignored for clean repo
- ✅ `.dockerignore` added
- ✅ Modules `slack_forwarder` & `alerting` fully managed by Terraform
- ✅ Unit tests for Lambda (`test_lambda_function.py`) running via GitHub Actions
- ✅ CloudWatch Dashboard tracking: Invocations, Duration, Errors
- ✅ `DYNAMODB_TABLE` and `REGION` read from environment variables with fallback

- ✅ CI/CD deployment fully working in `us-east-1`
- ✅ Lambda ZIP contains `utils.py` and works in production
- ✅ Frontend creates tasks, updates status (`PUT`) and fetches (`GET`)
- ✅ Fixed Terraform IAM role plan diff (no more destroy + recreate)
- ✅ Slack alerting works after IAM refactor (`lambda_exec`)


---

## 🛠️ IN PROGRESS

### 1. 🎨 Improve Slack Alert Formatting

- ✅ Format message body with function name, region, time
- ✅ Add severity emoji
- [ ] Include CloudWatch link (if possible)
Goal: Make alerts more readable and informative

```bash
🚨 LambdaErrors-ServerlessBackend-Test entered ALARM state!
Function: alert-forwarder
Region: us-east-1
Time: 2025-07-10 14:22 UTC
```

Extras: severity emoji, API link, function name, etc.

---

## 🔁 NEXT STEPS

### 2. 📊 Add More CloudWatch Metrics

- ✅ Add Lambda `Errors`
- ✅ Add `Invocations`, `Duration`
- ✅ Add `Throttles`
- [ ] (Optional) Grafana integration via CloudWatch datasource (in progress)

---

### 3. 🧪 Expand Unit Testing

- [ ] Add test for `DELETE` handler (non-existent `task_id`) *(optional enhancement)*
- ✅ Add test for missing body in `POST`
- [ ] Add test coverage for `slack_forwarder` Lambda
- ✅ Validate non-string titles (tests passed)

---

### 4. 🔃 Manual Lambda Build Helper

✅ Already done (`build.sh` added)

Optional:
- [ ] Add `.env` support
- [ ] Auto-detect region / bucket
- ✅ Use `make build` target

---

### 5. 🪵 Logging Improvements

- [ ] Add `X-Request-ID` or UUID to logs per request
- ✅ Standardize logs (method, path, etc.)

---

### 6. 📁 Project Metadata

- ✅ Add `/health` endpoint (returns 200 OK)
- ✅ Add  `DEVLOG.md`

---

### 7. 🔐 Security & Secrets

- ✅ Slack webhook managed in AWS Secrets Manager (instead of plain env vars)
- [ ] Rotate Slack webhook secret regularly
- [ ] Review IAM policies for least privilege (narrow down SecretsManager and Lambda execution rights)

---

### 8. 🧹 Repo Cleanup

- ✅ Remove old test ZIPs from repo history
- [ ] Consolidate Docker instructions in `docs/`

---

### 9. 📊 Monitoring & Observability

- ✅ Prometheus + Node Exporter running locally with Grafana
- [ ] Add CloudWatch exporter to Prometheus for AWS Lambda metrics
- [ ] Create Grafana dashboard for Lambda performance (duration, errors, throttles)

## 🧭 NOTES

- ✅ All deployed via Terraform
- ✅ No terraform import needed
- ✅ Works locally via `PYTHONPATH=terraform pytest`
- ✅ CI/CD includes `make test format lint`


updated 18/09/2025
