
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "jinali"

  default_tags {
    tags = {
      Environment = var.prefix
      Service     = "API Gateway"
    }
  }
}

terraform {
  backend "s3" {
    bucket  = "event-driven-ecom-terraform-states-dev"
    key     = "api-gateway/terraform.tfstate"
    region  = "ap-south-1"
    profile = "jinali"
  }
}

data "aws_lambda_function" "customer_service" {
  function_name = "customer-service-${var.prefix}"
}
data "aws_lambda_function" "order_service" {
  function_name = "order-service-${var.prefix}"
}

data "template_file" "_" {
  template = file("../api.yml")

  vars = {
    customer_service = data.aws_lambda_function.customer_service.invoke_arn
    order_service = data.aws_lambda_function.order_service.invoke_arn
  }
}


resource "aws_api_gateway_rest_api" "rest_api" {
  name        = var.rest_api_name
  description = var.api_description

  body = data.template_file._.rendered
}


resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = ""

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "rest_api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  depends_on    = [aws_cloudwatch_log_group.api_gw]
  stage_name    = var.rest_api_stage_name
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      ErrorMessage            = "$context.error.message"
      ValidationError         = "$context.error.validationErrorString"
      }
    )
  }
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "/aws/api_gw/${aws_api_gateway_rest_api.rest_api.name}"
  retention_in_days = var.retention_in_days
}





