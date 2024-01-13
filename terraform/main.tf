terraform {
  required_version = ">=1.5.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-south-1" #change aws region as per your need
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/zip/lambda_function_payload.zip"
}

resource "aws_lambda_function" "demo_lambda_function" {
  filename      = "${path.module}/zip/lambda_function_payload.zip"
  function_name = "lambda-function-demo"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "handler.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "nodejs18.x"

  environment {
    variables = {
      ENV = "dev" # lambda environment variables
    }
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
