output "execution_arn" {
  value = aws_apigatewayv2_api.api_gateway.execution_arn
}

output "api_url" {
  value       = "https://${aws_apigatewayv2_api.api_gateway.id}.execute-api.${var.region}.amazonaws.com/${aws_apigatewayv2_stage.api_stage.name}"
  description = "Full base URL for API Gateway"
}
# modules/apigateway/outputs.tf
output "api_id" {
  value = aws_apigatewayv2_api.api_gateway.id
}

output "invoke_url" {
  value = aws_apigatewayv2_stage.api_stage.invoke_url
}
output "healthcheck_url" {
  value = "${aws_apigatewayv2_api.api_gateway.api_endpoint}/health"
}

