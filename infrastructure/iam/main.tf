
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
      Service     = "iam"
    }
  }
}

terraform {
  backend "s3" {
    bucket  = "event-driven-ecom-terraform-states-dev"
    key     = "iam/terraform.tfstate"
    region  = "ap-south-1"
    profile = "jinali"
  }
}

data "aws_dynamodb_table" "customer_table" {
  name = "customer"
}
data "aws_dynamodb_table" "order_table" {
  name = "order"
}
data "aws_dynamodb_table" "product_table" {
  name = "product"
}


resource "aws_iam_policy" "customer_service_lambda_managed_policy" {
  name = "customer_service_lambda_managed_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:logs:*:*:*"]
      },
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Effect = "Allow"
        Resource = [
          data.aws_dynamodb_table.customer_table.arn
        ]
      }
    ]
  })

}

resource "aws_iam_policy" "order_service_lambda_managed_policy" {
  name = "order_service_lambda_managed_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:logs:*:*:*"]
      },
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Effect = "Allow"
        Resource = [
          data.aws_dynamodb_table.order_table.arn
        ]
      }
    ]
  })

}

resource "aws_iam_policy" "product_service_lambda_managed_policy" {
  name = "product_service_lambda_managed_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:logs:*:*:*"]
      },
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Effect = "Allow"
        Resource = [
          data.aws_dynamodb_table.product_table.arn
        ]
      }
    ]
  })
}