import os
import requests
import pytest

BASE_URL = os.getenv("LMS_BASE_URL", "http://127.0.0.1:8080")

@pytest.fixture(scope="session")
def client():
    try:
        response = requests.get(BASE_URL, timeout=3)
    except requests.RequestException as exc:
        pytest.skip(f"Start the Java application before HTTP smoke tests: {exc}")
    assert response.status_code == 200
    return requests.Session()

def test_dashboard_contains_library_title(client):
    response = client.get(BASE_URL)
    assert "Northbridge Public Library" in response.text

def test_catalog_search_finds_atomic_habits(client):
    response = client.get(f"{BASE_URL}/books", params={"q": "Atomic"})
    assert response.status_code == 200
    assert "Atomic Habits" in response.text

def test_unknown_search_shows_empty_message(client):
    response = client.get(f"{BASE_URL}/books", params={"q": "no-such-title"})
    assert "No matching books" in response.text
