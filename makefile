.PHONY: test format lint

test:
	PYTHONPATH=terraform pytest terraform/tests

format:
	black terraform/

lint:
	flake8 terraform/
