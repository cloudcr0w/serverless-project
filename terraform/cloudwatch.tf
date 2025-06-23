resource "aws_cloudwatch_dashboard" "lambda_dashboard" {
  dashboard_name = "ServerlessBackend-Dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0, y = 0, width = 24, height = 6,
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", "serverless-backend"],
            ["...", "Errors", "FunctionName", "serverless-backend"]
          ],
          period = 300,
          stat   = "Sum",
          region = "us-east-1",
          title  = "Lambda Activity Overview"
        }
      },
      {
        type = "metric",
        x    = 0, y = 6, width = 24, height = 6,
        properties = {
          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", "serverless-backend"]
          ],
          period = 300,
          stat   = "Average",
          region = "us-east-1",
          title  = "Lambda Duration (ms)"
        }
      }
    ]
  })
}
