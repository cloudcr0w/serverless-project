.PHONY: test format lint

test:
	pytest terraform/tests

format:
	black terraform/

lint:
	flake8 terraform/
