from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/health", methods=["GET"])
def healthcheck():
    return jsonify({"status": "ok"}), 200

if __name__ == "__main__":
    app.run(debug=True)

@app.route("/tasks", methods=["GET"])
def get_tasks():
    tasks = [
        {"task_id": "1", "title": "Buy milk", "status": "pending"},
        {"task_id": "2", "title": "Walk dog", "status": "completed"}
    ]
    return jsonify(tasks), 200

@app.route("/health")
def health_check():
    return jsonify({"status": "ok"}), 200