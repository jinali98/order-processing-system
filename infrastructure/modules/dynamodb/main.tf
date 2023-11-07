terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}


resource "aws_dynamodb_table" "dynamodb_table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key
  range_key      = var.range_key

  dynamic "attribute" {
    for_each = var.attribute
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.index_name
      hash_key           = global_secondary_index.value.index_hash_key
      projection_type    = global_secondary_index.value.index_projection_type
      range_key          = global_secondary_index.value.index_range_key
      read_capacity      = lookup(global_secondary_index.value, "index_read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "index_write_capacity", null)
      non_key_attributes = global_secondary_index.value.non_key_attributes
    }
  }
  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = local_secondary_index.value.index_name
      projection_type    = local_secondary_index.value.index_projection_type
      range_key          = local_secondary_index.value.index_range_key
      non_key_attributes = lookup(local_secondary_index.value, "index_non_key_attributes", null)
    }
  }

}
