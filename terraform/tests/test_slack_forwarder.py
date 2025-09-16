import json
import pytest
from unittest.mock import patch, MagicMock
import slack_alert_forwarder as saf


def test_get_slack_webhook_missing_secret(monkeypatch):
    """
    Test: when Secrets Manager doesn`t return secret > then goes exception
    """

    # Mock boto3 client
    mock_client = MagicMock()
    mock_client.get_secret_value.side_effect = Exception("Secret not found")

    with patch("boto3.client", return_value=mock_client):
        with pytest.raises(Exception, match="Secret not found"):
            saf.get_slack_webhook()
