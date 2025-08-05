import pytest
from terraform.utils import is_valid_title

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
