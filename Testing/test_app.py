import sys
from pathlib import Path

sys.path.insert(
    0,
    str(Path(__file__).resolve().parents[1] / "Application")
)

from app import app

def test_homepage():
    client = app.test_client()
    response = client.get("/")

    assert response.status_code == 200
    assert b"SriSolutions Australia" in response.data

def test_health():
    client = app.test_client()
    response = client.get("/health")
    assert response.status_code == 200
    data= response.get_json()
    assert data["status"] == "Healthy"

def test_about():
    client = app.test_client()
    response = client.get("/about")
    assert response.status_code == 200
    data = response.get_json()
    assert data["company"] == " SriSolutions Australia"