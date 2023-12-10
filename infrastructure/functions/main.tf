
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
  profile = var.profile


  default_tags {
    tags = {
      Environment = var.prefix
      Service     = "Functions"
    }
  }
}

terraform {
  backend "s3" {
    bucket  = "event-driven-ecom-terraform-states-dev"
    key     = "functions/terraform.tfstate"
    region  = "ap-south-1"
    profile = "jinali"
  }
}

data "aws_api_gateway_rest_api" "rest_api" {
  name = "event-driven-ecom-system"
}

data "aws_iam_policy" "customer_service_lambda_managed_policy" {
  name = "customer_service_lambda_managed_policy"
}
data "aws_iam_policy" "order_service_lambda_managed_policy" {
  name = "order_service_lambda_managed_policy"
}
data "aws_iam_policy" "product_service_lambda_managed_policy" {
  name = "product_service_lambda_managed_policy"
}


module "customer_service_lambda_function" {
  source                          = "../modules/function"
  lambda_zip_files_bucket         = "event-driven-customer-service-${var.prefix}"
  source_dir                      = "${path.root}/../../functions/customer-service/dist"
  output_path                     = "${path.root}/../../functions/customer-service/main.zip"
  s3_bucket_key                   = "main.zip"
  function_name                   = "customer-service-${var.prefix}"
  runtime                         = "nodejs18.x"
  memory_size                     = 128
  timeout                         = 30
  handler                         = "index.lambdaHandler"
  retention_in_days               = 14
  aws_iam_role_lambda_name        = "customer-service_${var.prefix}"
  managed_policy_name             = "customer-service_${var.prefix}"
  region                          = var.region
  statement_id                    = "AllowExecutionCutomerService"
  action                          = "lambda:InvokeFunction"
  principal                       = "apigateway.amazonaws.com"
  aws_lambda_permission_souce_arn = "${data.aws_api_gateway_rest_api.rest_api.execution_arn}/${var.prefix}/*/*"
}

module "order_service_lambda_function" {
  source                          = "../modules/function"
  lambda_zip_files_bucket         = "event-driven-order-service-${var.prefix}"
  source_dir                      = "${path.root}/../../functions/order-service/dist"
  output_path                     = "${path.root}/../../functions/order-service/main.zip"
  s3_bucket_key                   = "main.zip"
  function_name                   = "order-service-${var.prefix}"
  runtime                         = "nodejs18.x"
  memory_size                     = 128
  timeout                         = 30
  handler                         = "index.lambdaHandler"
  retention_in_days               = 14
  aws_iam_role_lambda_name        = "order-service_${var.prefix}"
  managed_policy_name             = "order-service_${var.prefix}"
  region                          = var.region
  statement_id                    = "AllowExecutionOrderService"
  action                          = "lambda:InvokeFunction"
  principal                       = "apigateway.amazonaws.com"
  aws_lambda_permission_souce_arn = "${data.aws_api_gateway_rest_api.rest_api.execution_arn}/${var.prefix}/*/*"
}

module "product_service_lambda_function" {
  source                          = "../modules/function"
  lambda_zip_files_bucket         = "event-driven-product-service-${var.prefix}"
  source_dir                      = "${path.root}/../../functions/product-service/dist"
  output_path                     = "${path.root}/../../functions/product-service/main.zip"
  s3_bucket_key                   = "main.zip"
  function_name                   = "product-service-${var.prefix}"
  runtime                         = "nodejs18.x"
  memory_size                     = 128
  timeout                         = 30
  handler                         = "index.lambdaHandler"
  retention_in_days               = 14
  aws_iam_role_lambda_name        = "product-service_${var.prefix}"
  managed_policy_name             = "product-service_${var.prefix}"
  region                          = var.region
  statement_id                    = "AllowExecutionProductService"
  action                          = "lambda:InvokeFunction"
  principal                       = "apigateway.amazonaws.com"
  aws_lambda_permission_souce_arn = "${data.aws_api_gateway_rest_api.rest_api.execution_arn}/${var.prefix}/*/*"
}


