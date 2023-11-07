
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
      Service     = "Database-Order-Processing"
    }
  }
}

terraform {
  backend "s3" {
    bucket  = "event-driven-ecom-terraform-states-dev"
    key     = "db/terraform.tfstate"
    region  = "ap-south-1"
    profile = "jinali"
  }
}

module "customer_table" {
  source         = "../modules/dynamodb"
  table_name     = "customer"
  hash_key       = "PK"
  range_key      = "SK"
  attribute = [
    {
      name = "PK"
      type = "S"
    },
    {
      name = "SK"
      type = "N"
    }
  ]

  global_secondary_indexes = []
  local_secondary_indexes  = []
}

module "product_table" {
  source         = "../modules/dynamodb"
  table_name     = "product"
  hash_key       = "PK"
  range_key      = "SK"
  attribute = [
    {
      name = "PK"
      type = "S"
    },
    {
      name = "SK"
      type = "S"
    }
  ]

  global_secondary_indexes = []
  local_secondary_indexes  = []
}

module "order_table" {
  source         = "../modules/dynamodb"
  table_name     = "order"
  hash_key       = "PK"
  range_key      = "SK"
  attribute = [
    {
      name = "PK"
      type = "S"
    },
    {
      name = "SK"
      type = "S"
    }
  ]

  local_secondary_indexes = []
  global_secondary_indexes = []
}
