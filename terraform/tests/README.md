## 🧪 Tests – Serverless Task Manager

This project includes unit tests for the Lambda backend and the Slack forwarder.
![Tests Result](test.png)
## Running Tests

From repo root:

```bash
make test
```

Or manually:
```bash
PYTHONPATH=terraform pytest terraform/tests -v
```

### Coverage

Run with coverage:
```bash
make coverage
```
or:
```bash
PYTHONPATH=terraform pytest --cov=terraform --cov-report=term-missing
```

## What is Tested?

- lambda_function.py

- Valid and invalid POST requests

- Title validation (non-empty string)

- Response codes and JSON structure

- slack_alert_forwarder.py

- Missing secret in AWS Secrets Manager

- Happy path with mocked boto3 + urllib3