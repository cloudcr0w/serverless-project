import os
import json
import boto3
import logging
import uuid

COMMON_HEADERS = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "OPTIONS,GET,POST,PUT,DELETE",
    "Access-Control-Allow-Headers": "Content-Type"
}

def is_valid_status(status):
    return status in ["pending", "completed"]

def is_valid_title(title):
    return isinstance(title, str) and len(title.strip()) > 0

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def log_with_request_id(message, request_id=None):
    rid = request_id or str(uuid.uuid4())
    print(f"[{rid}] {message}")
    return rid

def get_table():
    table_name = os.environ.get("DYNAMODB_TABLE") or "serverless-tasks"
    if not os.environ.get("DYNAMODB_TABLE"):
        logger.warning("⚠️ DYNAMODB_TABLE not set, using default 'serverless-tasks'")
    region = os.environ.get("REGION", "us-east-1")
    dynamodb = boto3.resource("dynamodb", region_name=region)
    return dynamodb.Table(table_name)

def lambda_handler(event, context):
    # safe method/path extraction
    method = event.get("httpMethod") or event.get("requestContext", {}).get("http", {}).get("method")
    path = event.get("path", "/")

    # one request_id per request
    request_id = str(uuid.uuid4())
    log_with_request_id(f"{(method or 'UNKNOWN')} {path} received", request_id)

    logger.info("[%s] Received event: %s", request_id, json.dumps(event))
    logger.info("[%s] Handling %s request", request_id, method)

    if not method:
        return response(400, {"error": "Invalid request structure"}, request_id)

    if method == "GET" and path == "/health":
        return {
            "statusCode": 200,
            "headers": COMMON_HEADERS,
            "body": json.dumps({"status": "ok"})
        }

    if method == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": COMMON_HEADERS,
            "body": json.dumps({"message": "CORS preflight response"}),
        }

    if method == "GET" and path == "/metrics":
        return {
            "statusCode": 200,
            "headers": COMMON_HEADERS,
            "body": "lambda_invocations_total 42\nlambda_errors_total 1",
        }

    if method == "POST":
        return create_task(event, request_id)
    elif method == "GET":
        return get_tasks(request_id)
    elif method == "DELETE":
        return delete_task(event, request_id)
    elif method == "PUT":
        return update_task_status(event, request_id)
    else:
        return response(400, {"error": "Invalid request method"}, request_id)

def create_task(event, request_id):
    if "body" not in event or not event["body"]:
        return response(400, {"error": "Empty request body"}, request_id)

    body = json.loads(event["body"])

    title = body.get("title")
    if not is_valid_title(title):
        return response(400, {"error": "Invalid or missing title"}, request_id)

    new_status = body.get("status", "pending")
    if not is_valid_status(new_status):
        return response(400, {"error": "Invalid status value"}, request_id)

    if title == "FAIL":
        raise Exception("💥 Simulated failure for CloudWatch Alarm test")

    try:
        task_id = str(uuid.uuid4())
        task = {"task_id": task_id, "title": title, "status": new_status}
        get_table().put_item(Item=task)
        logger.info("[%s] Task created: %s", request_id, json.dumps(task))
        return response(201, {"message": "Task created", "task": task}, request_id)
    except Exception as e:
        logger.error("[%s] Error creating task: %s", request_id, str(e), exc_info=True)
        return response(500, {"error": "Failed to create task"}, request_id)

def get_tasks(request_id):
    try:
        logger.info("[%s] Fetching all tasks from DynamoDB", request_id)
        response_scan = get_table().scan()
        tasks = response_scan.get("Items", [])
        for task in tasks:
            if "id" in task and "task_id" not in task:
                task["task_id"] = task.pop("id")
        logger.info("[%s] Fetched %d tasks", request_id, len(tasks))
        return response(200, tasks, request_id)
    except Exception as e:
        logger.error("[%s] Error fetching tasks: %s", request_id, str(e), exc_info=True)
        return response(500, {"error": "Failed to fetch tasks"}, request_id)

def delete_task(event, request_id):
    try:
        task_id = (event.get("pathParameters") or {}).get("task_id")
        if not task_id:
            return response(400, {"error": "Missing task_id in path parameters"}, request_id)
        get_table().delete_item(Key={"task_id": task_id})
        logger.info("[%s] Deleted task: %s", request_id, task_id)
        return response(200, {"message": f"Task {task_id} deleted"}, request_id)
    except Exception as e:
        logger.error("[%s] Error deleting task: %s", request_id, str(e), exc_info=True)
        return response(500, {"error": "Failed to delete task"}, request_id)

def update_task_status(event, request_id):
    try:
        path_params = event.get("pathParameters") or {}
        task_id = path_params.get("task_id")
        if not task_id:
            return response(400, {"error": "Missing task_id in path parameters"}, request_id)

        body = json.loads(event.get("body", "{}"))
        new_status = body.get("status")
        if not is_valid_status(new_status):
            return response(400, {"error": "Invalid status value"}, request_id)

        table = get_table()
        table.update_item(
            Key={"task_id": task_id},
            UpdateExpression="SET #s = :status",
            ExpressionAttributeNames={"#s": "status"},
            ExpressionAttributeValues={":status": new_status},
        )
        logger.info("[%s] Updated task %s with status %s", request_id, task_id, new_status)
        return response(200, {"message": f"Task {task_id} updated", "status": new_status}, request_id)
    except Exception as e:
        logger.error("[%s] Error updating task status: %s", request_id, str(e), exc_info=True)
        return response(500, {"error": "Failed to update task"}, request_id)

def response(status_code, body_dict, request_id=None):
    headers = COMMON_HEADERS.copy()
    if request_id:
        headers["X-Request-ID"] = request_id
    return {
        "statusCode": status_code,
        "headers": headers,
        "body": json.dumps(body_dict),
    }
# TODO: Consider refactoring filtering logic
