# 🛠️ TODO – Serverless Task Manager: Alerting, Terraform Sync & Cleanup

---

## ✅ DONE

- [x] Lambda backend works with simulated `FAIL` (`CloudWatch Alarm → SNS → Slack`)
- [x] Slack alerting verified — webhook functional, messages received
- [x] GitHub Actions: Terraform plan/apply + Lambda ZIP build & upload
- [x] `.gitignore` updated — ZIPs ignored for clean repo
- [x] `.dockerignore` added
- [x] Modules `slack_forwarder` & `alerting` fully managed by Terraform
- [x] Unit tests for Lambda (`test_lambda_function.py`) running via GitHub Actions
- [x] CloudWatch Dashboard tracking: Invocations, Duration, Errors
- [x] `DYNAMODB_TABLE` and `REGION` read from environment variables with fallback

- [x] ✅ CI/CD deployment fully working in `us-east-1`
- [x] ✅ Lambda ZIP contains `utils.py` and works in production
- [x] ✅ Frontend creates tasks, updates status (`PUT`) and fetches (`GET`)
- [x] ✅ Fixed Terraform IAM role plan diff (no more destroy + recreate)
- [x] ✅ Slack alerting works after IAM refactor (`lambda_exec`)


---

## 🛠️ IN PROGRESS

### 1. 🎨 Improve Slack Alert Formatting

Goal: Make alerts more readable and informative, e.g.:

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

- [x] Add Lambda `Errors`
- [x] Add `Invocations`, `Duration`
- [x] Add `Throttles`
- [ ] (Optional) Grafana integration via CloudWatch datasource

---

### 3. 🧪 Expand Unit Testing

- [ ] Add test for `DELETE` handler (non-existent `task_id`)
- [ ] Add test for missing body in `POST`
- [ ] Add test coverage for `slack_forwarder` Lambda

---

### 4. 🔃 Manual Lambda Build Helper

✅ Already done (`build.sh` added)

Optional:
- [ ] Add `.env` support
- [ ] Auto-detect region / bucket
- [ ] Use `make build` target

---

### 5. 🪵 Logging Improvements

- [ ] Add `X-Request-ID` or UUID to logs per request
- [ ] Standardize logs (method, path, etc.)

---

### 6. 📁 Project Metadata

- [ ] Add `/health` endpoint (returns 200 OK)
- [ ] Add `changelog.md` or extend `DEVLOG.md`

---

## 🧭 NOTES

- ✅ All deployed via Terraform
- ✅ No terraform import needed
- ✅ Works locally via `PYTHONPATH=terraform pytest`
- ✅ CI/CD includes `make test format lint`
