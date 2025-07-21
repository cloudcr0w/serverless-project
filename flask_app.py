from flask import Flask, request, jsonify
import uuid

app = Flask(__name__)

TASKS = {}

@app.route("/tasks", methods=["GET"])
def list_tasks():
    return jsonify(list(TASKS.values())), 200

@app.route("/tasks", methods=["POST"])
def create_task():
    data = request.get_json()
    task_id = str(uuid.uuid4())
    task = {
        "id": task_id,
        "title": data.get("title", ""),
        "completed": False
    }
    TASKS[task_id] = task
    return jsonify(task), 201

@app.route("/tasks/<task_id>", methods=["PUT"])
def update_task(task_id):
    if task_id not in TASKS:
        return jsonify({"error": "Task not found"}), 404

    data = request.get_json()
    TASKS[task_id]["title"] = data.get("title", TASKS[task_id]["title"])
    TASKS[task_id]["completed"] = data.get("completed", TASKS[task_id]["completed"])
    return jsonify(TASKS[task_id]), 200

@app.route("/tasks/<task_id>", methods=["DELETE"])
def delete_task(task_id):
    if task_id not in TASKS:
        return jsonify({"error": "Task not found"}), 404

    deleted = TASKS.pop(task_id)
    return jsonify(deleted), 200

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
