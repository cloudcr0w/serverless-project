from unittest.mock import patch, MagicMock
import json
import pytest
import lambda_function

class FakeContext:
    def __init__(self):
        self.function_name = "test"

def make_event(body):
    return {
        "body": json.dumps(body),
        "httpMethod": "POST"
    }

@patch("lambda_function.boto3.resource")
def test_valid_post(mock_resource):
    # Mockowanie obiektu tabeli
    mock_table = MagicMock()
    mock_resource.return_value.Table.return_value = mock_table
    mock_table.put_item.return_value = {"ResponseMetadata": {"HTTPStatusCode": 200}}

    event = make_event({"title": "Buy milk"})
    response = lambda_function.lambda_handler(event, FakeContext())
    assert response["statusCode"] == 201
    task = json.loads(response["body"]).get("task", {})
    assert "task_id" in task
    assert task["title"] == "Buy milk"

@patch("lambda_function.boto3.resource")
@pytest.mark.parametrize("bad_title", [None, "", "   ", 123])
def test_invalid_post_titles(mock_resource, bad_title):
    event = make_event({"title": bad_title})
    response = lambda_function.lambda_handler(event, FakeContext())
    assert response["statusCode"] == 400
    assert "error" in json.loads(response["body"])
