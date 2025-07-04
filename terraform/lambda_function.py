import json
import boto3
import uuid
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_table():
    dynamodb = boto3.resource("dynamodb")
    return dynamodb.Table("serverless-tasks")

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    method = event.get(
        "httpMethod", event.get("requestContext", {}).get("http", {}).get("method")
    )

    if not method:
        return response(400, {"error": "Invalid request structure"})

    if method == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET,POST,DELETE,OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type",
                "Content-Type": "application/json",
                "X-Content-Type-Options": "nosniff",
            },
            "body": json.dumps({"message": "CORS preflight response"}),
        }
    if method == "POST":
        return create_task(event)
    elif method == "GET":
        return get_tasks()
    elif method == "DELETE":
        return delete_task(event)
    else:
        return response(400, {"error": "Invalid request method"})

def create_task(event):
    body = json.loads(event["body"])
    if "body" not in event or not event["body"]:
        return response(400, {"error": "Empty request body"})

    if "title" not in body or not isinstance(body["title"], str) or not body["title"].strip():
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

def response(status_code, body_dict):
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET,POST,DELETE,OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type",
            "X-Content-Type-Options": "nosniff",
        },
        "body": json.dumps(body_dict),
    }