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


def test_valid_post():
    event = make_event({"title": "Buy milk"})
    response = lambda_function.lambda_handler(event, FakeContext())
    assert response["statusCode"] == 201
    task = json.loads(response["body"]).get("task", {})
    assert "task_id" in task
    assert task["title"] == "Buy milk"

def test_missing_title():
    event = make_event({})
    response = lambda_function.lambda_handler(event, FakeContext())
    assert response["statusCode"] == 400
    assert "error" in json.loads(response["body"])

def test_fail_title_triggers_error():
    event = make_event({"title": "FAIL"})
    with pytest.raises(Exception) as e:
        lambda_function.lambda_handler(event, FakeContext())
    assert "Simulated failure" in str(e.value)
