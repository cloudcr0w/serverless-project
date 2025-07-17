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
    mock_table = MagicMock()
    mock_resource.return_value.Table.return_value = mock_table
    mock_table.put_item.return_value = {"ResponseMetadata": {"HTTPStatusCode": 200}}

    event = make_event({"title": "Buy milk"})
    response = lambda_function.lambda_handler(event, FakeContext())
    assert response["statusCode"] == 201
    task = json.loads(response["body"]).get("task", {})
    assert "id" in task
    assert task["title"] == "Buy milk"

@patch("lambda_function.boto3.resource")
@pytest.mark.parametrize("bad_title", [None, "", "   ", 123])

def test_invalid_post_titles(mock_resource, bad_title):
    event = make_event({"title": bad_title})
    response = lambda_function.lambda_handler(event, FakeContext())
    assert response["statusCode"] == 400
    assert "error" in json.loads(response["body"])

def test_options_request():
    event = {
        "httpMethod": "OPTIONS"
    }
    response = lambda_function.lambda_handler(event, None)
    assert response["statusCode"] == 200
    assert "Access-Control-Allow-Origin" in response["headers"]

def test_post_without_body():
    event = {
        "httpMethod": "POST"
    
    }
    response = lambda_function.lambda_handler(event, None)
    assert response["statusCode"] == 400
    assert "error" in json.loads(response["body"])

@patch("lambda_function.boto3.resource")
def test_delete_task(mock_resource):
    mock_table = MagicMock()
    mock_resource.return_value.Table.return_value = mock_table
    mock_table.delete_item.return_value = {"ResponseMetadata": {"HTTPStatusCode": 200}}

    event = {
        "httpMethod": "DELETE",
        "pathParameters": {"id": "1234"}
    }
    response = lambda_function.lambda_handler(event, None)
    assert response["statusCode"] == 200
    assert "deleted" in json.loads(response["body"]).get("message", "")
    
@patch("lambda_function.boto3.resource")
def test_update_task_status(mock_resource):
    mock_table = MagicMock()
    mock_resource.return_value.Table.return_value = mock_table
    mock_table.update_item.return_value = {"ResponseMetadata": {"HTTPStatusCode": 200}}

    event = {
        "httpMethod": "PUT",
        "pathParameters": {"id": "abcd-1234"},
        "body": json.dumps({"status": "done"})
    }

    response = lambda_function.lambda_handler(event, None)
    assert response["statusCode"] == 200
    body = json.loads(response["body"])
    assert body["status"] == "done"
    assert "updated" in body["message"]
