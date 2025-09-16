import json
import pytest
from unittest.mock import patch, MagicMock
import slack_alert_forwarder as saf


def test_get_slack_webhook_missing_secret(monkeypatch):
    """
    Test: when Secrets Manager does not return a secret → should raise Exception.
    """

    # Mock boto3 client to simulate missing secret
    mock_client = MagicMock()
    mock_client.get_secret_value.side_effect = Exception("Secret not found")

    # Patch boto3 client and expect an Exception
    with patch("boto3.client", return_value=mock_client):
        with pytest.raises(Exception, match="Secret not found"):
            saf.get_slack_webhook()


def test_lambda_handler_happy_path(monkeypatch):
    """
    Test: valid secret in Secrets Manager + SNS event → Slack request succeeds.
    """

    # 1. Mock boto3 client → returns fake Slack webhook URL
    mock_client = MagicMock()
    mock_client.get_secret_value.return_value = {
        "SecretString": "https://hooks.slack.com/services/FAKE/SECRET/URL"
    }
    monkeypatch.setattr("boto3.client", lambda *args, **kwargs: mock_client)

    # 2. Mock urllib3 → simulate HTTP 200 response
    mock_http = MagicMock()
    mock_http.request.return_value.status = 200
    monkeypatch.setattr(saf, "http", mock_http)

    # 3. Sample SNS event payload
    event = {
        "Records": [
            {
                "Sns": {
                    "Message": json.dumps({
                        "AlarmName": "TestAlarm",
                        "NewStateValue": "ALARM",
                        "NewStateReason": "Threshold breached",
                        "Region": "us-east-1",
                        "StateChangeTime": "2025-09-16T10:00:00Z"
                    })
                }
            }
        ]
    }

    # 4. Call the Lambda handler with mocked event
    saf.lambda_handler(event, None)

    # 5. Assert that Slack webhook was called with correct payload
    mock_http.request.assert_called_once()
    args, kwargs = mock_http.request.call_args
    assert kwargs["headers"]["Content-Type"] == "application/json"
    assert b"TestAlarm" in kwargs["body"]
