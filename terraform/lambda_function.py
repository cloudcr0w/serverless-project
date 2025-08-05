import os
import json
import boto3
import uuid
import logging
from terraform.utils import COMMON_HEADERS


logger = logging.getLogger()
logger.setLevel(logging.INFO)


def get_table():
    table_name = os.environ.get("DYNAMODB_TABLE")
    if not table_name:
        logger.warning("⚠️ DYNAMODB_TABLE not set, using default 'serverless-tasks'")
        table_name = "serverless-tasks"

    region = os.environ.get("REGION", "us-east-1")
    dynamodb = boto3.resource("dynamodb", region_name=region)
    return dynamodb.Table(table_name)


def lambda_handler(event, context):
    method = event.get("httpMethod")
    if not method:
        method = event.get("requestContext", {}).get("http", {}).get("method")

    path = event.get("path", "/")

    request_id = str(uuid.uuid4())
    logger.info("[%s] %s %s received", request_id, method, path)

    logger.info("Received event: %s", json.dumps(event))
    logger.info("Handling %s request", method)

    if not method:
        return response(400, {"error": "Invalid request structure"})

    if method == 'GET' and path == '/health':
        return {
            "statusCode": 200,
            "body": json.dumps({"status": "ok"})
        }

    if method == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": COMMON_HEADERS,
            "body": json.dumps({"message": "CORS preflight response"}),
        }

    if method == "POST":
        return create_task(event)
    elif method == "GET":
        return get_tasks()
    elif method == "DELETE":
        return delete_task(event)
    elif method == "PUT":
        return update_task_status(event)
    else:
        return response(400, {"error": "Invalid request method"}, request_id)




def create_task(event):
    if "body" not in event or not event["body"]:
        return response(400, {"error": "Empty request body"})

    body = json.loads(event["body"])

    if (
        "title" not in body
        or not isinstance(body["title"], str)
        or not body["title"].strip()
    ):
        return response(400, {"error": "Invalid or missing title"})

    if body.get("title") == "FAIL":
        raise Exception("💥 Simulated failure for CloudWatch Alarm test")

    try:
        task_id = str(uuid.uuid4())
        task = {
            "task_id": task_id,
            "title": body["title"],
            "status": body.get("status", "pending"),
        }

        get_table().put_item(Item=task)
        logger.info("Task created: %s", json.dumps(task))

        return response(201, {"message": "Task created", "task": task})
    except Exception as e:
        logger.error("Error creating task: %s", str(e), exc_info=True)
        return response(500, {"error": "Failed to create task"})

def get_tasks():
    try:
        response_scan = get_table().scan()
        tasks = response_scan.get("Items", [])

        # 🛠️ Konwersja id → task_id dla spójności
        for task in tasks:
            if "id" in task and "task_id" not in task:
                task["task_id"] = task.pop("id")

        logger.info("Fetched %d tasks", len(tasks))
        return response(200, tasks)
    except Exception as e:
        logger.error("Error fetching tasks: %s", str(e), exc_info=True)
        return response(500, {"error": "Failed to fetch tasks"})

def delete_task(event):
    try:
        task_id = event["pathParameters"]["task_id"]
        get_table().delete_item(Key={"task_id": task_id})
        logger.info("Deleted task: %s", task_id)

        return response(200, {"message": f"Task {task_id} deleted"})
    except Exception as e:
        logger.error("Error deleting task: %s", str(e), exc_info=True)
        return response(500, {"error": "Failed to delete task"})

def update_task_status(event):
    try:
        path_params = event.get("pathParameters")
        if not path_params or "task_id" not in path_params:
            return response(400, {"error": "Missing task_id in path parameters"})

        task_id = path_params["task_id"]
        body = json.loads(event.get("body", "{}"))
        new_status = body.get("status")

        if new_status not in ["pending", "done"]:
            return response(400, {"error": "Invalid status value"})

        table = get_table()
        table.update_item(
            Key={"task_id": task_id},
            UpdateExpression="SET #s = :status",
            ExpressionAttributeNames={"#s": "status"},
            ExpressionAttributeValues={":status": new_status},
        )

        logger.info(f"Updated task {task_id} with status {new_status}")
        return response(200, {"message": f"Task {task_id} updated", "status": new_status})

    except Exception as e:
        logger.error("Error updating task status: %s", str(e), exc_info=True)
        return response(500, {"error": "Failed to update task"})

def response(status_code, body_dict, request_id=None):
    headers = COMMON_HEADERS.copy()
    if request_id:
        headers["X-Request-ID"] = request_id

    return {
        "statusCode": status_code,
        "headers": headers,
        "body": json.dumps(body_dict),
    }

