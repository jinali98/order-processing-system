

variable "table_name" {
  type        = string
  description = "name of the dynamodb table"
}
variable "hash_key" {
  type        = string
  description = "hash_key of the dynamodb table"
}
variable "range_key" {
  type        = string
  description = "range_key of the dynamodb table"
}

variable "attribute" {
  type = list(object({
    name : string,
    type : string
  }))
}
variable "global_secondary_indexes" {
  description = "Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc."
  type = list(object({
    index_name            = string
    index_projection_type = string
    index_range_key       = optional(string)
    index_hash_key        = string
    non_key_attributes    = list(string)
    index_read_capacity   = number
    index_write_capacity  = number
  }))
}
variable "local_secondary_indexes" {
  description = "Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc."
  type = list(object({
    index_name               = string
    index_projection_type    = string
    index_range_key          = string
    index_non_key_attributes = list(string)
  }))
}