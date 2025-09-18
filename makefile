.PHONY: test format lint plan deploy coverage monitoring-up monitoring-down validate fmt plan-out apply-out clean

test:
	PYTHONPATH=terraform pytest terraform/tests -v

format:
	black terraform/

lint:
	flake8 terraform/

plan:
	cd terraform && terraform plan

plan-out:
	cd terraform && terraform plan -out=tfplan

apply-out:
	cd terraform && terraform apply tfplan

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

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	rm -rf .pytest_cache *.pyc *.pyo
