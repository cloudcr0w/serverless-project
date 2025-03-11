import json
import boto3
import uuid

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("serverless-tasks")

def lambda_handler(event, context):
    """ Main handler for AWS Lambda triggered by API Gateway """
    print("Received event:", json.dumps(event))  # Logowanie eventu do CloudWatch

    method = event.get("httpMethod")  # Obsługa metod API Gateway

    if not method:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid request structure"})
        }

    if method == "POST":
        return create_task(event)
    elif method == "GET":
        return get_tasks()
    elif method == "DELETE":
        return delete_task(event)
    else:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid request method"})
        }

def create_task(event):
    """ Creates a new task in DynamoDB """
    try:
        body = json.loads(event["body"])
        task_id = str(uuid.uuid4())  # Generate a unique task ID
        task = {
            "task_id": task_id,
            "title": body["title"],
            "status": body.get("status", "pending")
        }

        table.put_item(Item=task)

        return {
            "statusCode": 201,
            "body": json.dumps({"message": "Task created", "task": task})
        }
    except Exception as e:
        print("Error creating task:", str(e))
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Failed to create task"})
        }

def get_tasks():
    """ Fetches all tasks from DynamoDB """
    try:
        response = table.scan()
        tasks = response.get("Items", [])

        return {
            "statusCode": 200,
            "body": json.dumps(tasks)
        }
    except Exception as e:
        print("Error fetching tasks:", str(e))
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Failed to fetch tasks"})
        }

def delete_task(event):
    """ Deletes a task from DynamoDB """
    try:
        task_id = event["pathParameters"]["task_id"]  # Pobieramy ID z URL

        table.delete_item(Key={"task_id": task_id})

        return {
            "statusCode": 200,
            "body": json.dumps({"message": f"Task {task_id} deleted"})
        }
    except Exception as e:
        print("Error deleting task:", str(e))
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Failed to delete task"})
        }
