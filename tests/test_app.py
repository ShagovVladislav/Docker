import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from src.app import app

def test_health():
    client = app.test_client()
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.get_json() == {"status": "healthy"}
