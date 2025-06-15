import json
import os
import urllib3

http = urllib3.PoolManager()
SLACK_WEBHOOK_URL = os.environ.get("SLACK_WEBHOOK_URL")

def lambda_handler(event, context):
    print("🔍 Received event:", json.dumps(event))
    
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
        
        resp = http.request(
            "POST",
            SLACK_WEBHOOK_URL,
            body=encoded_msg,
            headers={"Content-Type": "application/json"},
            timeout=10.0 
        )

        print(f"Slack response: {resp.status}")
