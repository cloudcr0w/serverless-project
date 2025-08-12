from app import app

if __name__ == "__main__":
    app.run(debug=True)

def metrics():
    return Response("tasks_total 0\n", mimetype="text/plain")