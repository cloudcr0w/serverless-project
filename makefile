.PHONY: test format lint plan deploy

test:
	PYTHONPATH=terraform pytest terraform/tests

format:
	black terraform/

lint:
	flake8 terraform/

plan:
	cd terraform && terraform plan

deploy:
	./build.sh
	cd terraform && terraform apply -auto-approve

coverage:
	PYTHONPATH=. pytest --cov=terraform.lambda_function --cov-report=term-missing
