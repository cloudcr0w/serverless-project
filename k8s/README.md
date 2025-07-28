# Kubernetes configs

This folder contains Kubernetes configuration files for local testing of the Serverless Task Manager backend.

## Files

- `deployment.yaml` — Deploys the Flask-based API using a local image (`imagePullPolicy: Never`)
- `configmap.yaml` — Provides environment variables like `REGION` and `DYNAMODB_TABLE`
- `service.yaml` — Exposes the pod as a `NodePort` service for external access (e.g. via Minikube)
- `secret.yaml` — **Not included in the repo.**  
  Create manually using:

  ```bash
  kubectl create secret generic task-manager-secret \
    --from-literal=SLACK_WEBHOOK_URL="https://hooks.slack.com/services/xxx/yyy/zzz"
