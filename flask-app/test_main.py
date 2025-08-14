from app import app
from routes import api


def test_health_check():
    with app.test_client() as client:
        response = client.get("/health")
        assert response.status_code == 200
        assert response.json == {"status": "ok"}

def test_version():
    with app.test_client() as client:
        res = client.get("/version")
        assert res.status_code == 200
        assert res.json == {"version": "1.0.0"}
