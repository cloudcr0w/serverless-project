.PHONY: test format lint plan deploy coverage monitoring-up monitoring-down validate fmt

test:
	PYTHONPATH=terraform pytest terraform/tests -v

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

# New targets
monitoring-up:
	cd monitoring && docker compose up -d

monitoring-down:
	cd monitoring && docker compose down

validate:
	cd terraform && terraform validate

fmt:
	terraform fmt -recursive
