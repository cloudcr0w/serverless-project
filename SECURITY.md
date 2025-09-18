# 🔐 Security Policy

## Secrets Management
- Slack webhook URL is stored in **AWS Secrets Manager**, not in plain environment variables.
- Lambda IAM role has **least privilege** access → read-only permission for this secret.
- Future plan: enable **automatic secret rotation**.

## Infrastructure
- All resources are provisioned via **Terraform** (Infrastructure as Code).
- IAM policies are modular and follow **principle of least privilege**.

## Reporting Issues
If you discover a security vulnerability in this project, please open an issue or contact me directly.

## Contact
- Email: adamwronowy@gmail.com
- GitHub: [cloudcr0w](https://github.com/cloudcr0w)
