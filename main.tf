module "iam" {
  source = "./modules/iam"
}

# could be moved to s3?
data "archive_file" "example_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/lambda.zip"
}

# runs every day, could easily be changed to a different frequency via. rate() expression syntax
resource "aws_cloudwatch_event_rule" "every_hour" {
  name                = "every_hour_rule"
  description         = "meant to trigger a lambda every hour"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_hour.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.example_function.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_hour.arn
}

resource "aws_lambda_function" "example_function" {
  filename      = "${path.module}/python/lambda.zip"
  function_name = "example_lambda"
  handler       = "lambda_function.lambda_handler"
  role          = module.iam.iam_role_arn
  runtime       = "python3.8"
  timeout       = 10 # increased as this can hit cold starts
}