terraform {
  backend "s3" {
    bucket  = "adamwrona-terraform-state"
    key     = "serverless-project/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "adamwrona-serverless-frontend"
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "serverless-tasks"
}

module "iam" {
  source             = "./modules/iam"
  dynamodb_table_arn = module.dynamodb.dynamodb_table_arn
}

module "apigateway" {
  source              = "./modules/apigateway"
  lambda_function_arn = module.lambda.lambda_function_arn
}

module "lambda" {
  source              = "./modules/lambda"
  lambda_role_arn     = module.iam.lambda_role_arn
  api_execution_arn   = module.apigateway.execution_arn
  dynamodb_table_name = module.dynamodb.dynamodb_table_name
}

module "alerting" {
  source               = "./modules/alerting"
  lambda_function_name = module.lambda.function_name
}

module "slack_forwarder" {
  source            = "./modules/slack_forwarder"
  lambda_role_arn   = module.iam.lambda_role_arn
  lambda_role_name  = module.iam.lambda_role_name
  sns_topic_arn     = module.alerting.sns_topic_arn
  slack_webhook_url = var.slack_webhook_url
}
