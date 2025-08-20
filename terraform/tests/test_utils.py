import pytest
from utils import is_valid_title
from utils import is_valid_status


@pytest.mark.parametrize("title,expected", [
    ("Buy milk", True),
    ("  Clean room  ", True),
    ("", False),
    ("   ", False),
    (None, False),
    (123, False),
])
def test_is_valid_title(title, expected):
    assert is_valid_title(title) == expected

@pytest.mark.parametrize("status,expected", [
    ("pending", True),
    ("in progress", True),
    ("completed", True),
    ("done", False),
    ("", False),
    (None, False),
])
def test_is_valid_status(status, expected):
    assert is_valid_status(status) == expected
