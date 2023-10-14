# tf-scheduled lambda

## Introduction and Goals

- Used more complex code in [aws-month-cost-datadog-lambda-tf](https://github.com/EmilyBurak/aws-month-cost-datadog-lambda-tf) and wanted to produce a minimal example of a scheduled lambda.

## Technologies used

- boto3
- Lambda for running the boto3 code in a serverless fashion
- EventBridge for hourly Lambda triggering
- IAM for the inter-service permissions required

## How It Works

The core code is in `/python/lambda_function.py`, which is zipped by **Terraform** and used by **Lambda**. It pulls as a toy example the [details about the account's lambda settings](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/lambda/client/get_account_settings.html)
**IAM** is used to make sure services(Lambda and **EventBridge** using a **CloudWatch Event Rule**) can speak to each other and call lambda's settings.
Currently using local state, I'll leave setting up remote state to you.

## How To Use

- Set up AWS environment variables for running Terraform against your account and an appropriate IAM user
- Run Terraform code included with the core TF workflow(`terraform init` --> `terraform plan` --> `terraform apply`)
- Check the results in the Lambda console.

## Resources

- https://spacelift.io/blog/terraform-aws-lambda
