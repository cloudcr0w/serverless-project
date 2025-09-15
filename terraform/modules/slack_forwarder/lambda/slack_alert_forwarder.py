import json
import logging
import urllib3
import boto3

http = urllib3.PoolManager()
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_slack_webhook():
    secret_name = "slack-webhook-url"
    region_name = "us-east-1"

    client = boto3.client("secretsmanager", region_name=region_name)

    try:
        response = client.get_secret_value(SecretId=secret_name)
        secret = response["SecretString"]
        # jeśli secret jest w formacie JSON {"url": "..."} → wyciągamy "url"
        if secret.startswith("{"):
            parsed = json.loads(secret)
            return parsed.get("url", "")
        return secret
    except Exception as e:
        logger.error(f"❌ Error retrieving secret: {e}")
        raise e

def lambda_handler(event, context):
    print("🔍 Received event:", json.dumps(event))

    webhook_url = get_slack_webhook()
    if not webhook_url:
        logger.error("❌ No Slack webhook URL found in Secrets Manager")
        return {"statusCode": 500, "body": "Slack webhook not found"}

    for record in event["Records"]:
        sns_msg = json.loads(record["Sns"]["Message"])

        alarm_name = sns_msg.get("AlarmName", "UnknownAlarm")
        state = sns_msg.get("NewStateValue", "UNKNOWN")
        reason = sns_msg.get("NewStateReason", "No reason provided")
        region = sns_msg.get("Region", "unknown")
        time = sns_msg.get("StateChangeTime", "unknown time")

        emoji = {
            "ALARM": "🚨",
            "OK": "✅",
            "INSUFFICIENT_DATA": "⚠️"
        }.get(state, "❓")

        formatted_text = f"""{emoji} *{alarm_name}* changed state to *{state}*
> {reason}
🌍 Region: `{region}`
🕒 Time: `{time}`"""

        payload = {"text": formatted_text}
        encoded_msg = json.dumps(payload).encode("utf-8")

        try:
            resp = http.request(
                "POST",
                webhook_url,
                body=encoded_msg,
                headers={"Content-Type": "application/json"},
                timeout=10.0
            )
            logger.info(f"✅ Slack response: {resp.status}")
        except Exception as e:
            logger.error(f"❌ Error sending to Slack: {e}")
            raise e
