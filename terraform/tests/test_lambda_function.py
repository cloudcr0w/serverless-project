import json
import lambda_function

class FakeContext:
    def __init__(self):
        self.function_name = "test"

def make_event(body):
    return {
        "body": json.dumps(body)
    }

def test_valid_post():
    event = make_event({"title": "Buy milk"})
    response = lambda_function.lambda_handler(event, FakeContext())
    assert response["statusCode"] == 200
    assert "id" in json.loads(response["body"])

def test_missing_title():
    event = make_event({})
    response = lambda_function.lambda_handler(event, FakeContext())
    assert response["statusCode"] == 400
    assert "error" in json.loads(response["body"])

def test_fail_title_triggers_error():
    event = make_event({"title": "FAIL"})
    response = lambda_function.lambda_handler(event, FakeContext())
    assert response["statusCode"] == 500
    assert "error" in json.loads(response["body"])
