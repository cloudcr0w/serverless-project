COMMON_HEADERS = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE,OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    "X-Content-Type-Options": "nosniff",
}
def is_valid_title(title):
    if isinstance(title, str) and title.strip():
        return True
    return False


def is_valid_status(value: str) -> bool:
    return value in {"pending", "done"}
