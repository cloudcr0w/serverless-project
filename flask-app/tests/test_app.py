from flask_app.app import app

def test_healthcheck():
    with app.test_client() as client:
        response = client.get("/health")
        assert response.status_code == 200
        assert response.json == {"status": "ok"}

def test_get_tasks():
    with app.test_client() as client:
        response = client.get("/tasks")
        assert response.status_code == 200
        assert isinstance(response.json, list)
        assert all("task_id" in t for t in response.json)
