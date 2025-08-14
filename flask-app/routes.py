from flask import Blueprint, jsonify

api = Blueprint("api", __name__)

@api.route("/health", methods=["GET"])
def healthcheck():
    return jsonify({"status": "ok"}), 200

@api.route("/tasks", methods=["GET"])
def get_tasks():
    tasks = [
        {"task_id": "1", "title": "Buy milk", "status": "pending"},
        {"task_id": "2", "title": "Walk dog", "status": "completed"}
    ]
    return jsonify(tasks), 200

@api.route("/version")
def version():
    return jsonify({"version": "1.0.0"}), 200
