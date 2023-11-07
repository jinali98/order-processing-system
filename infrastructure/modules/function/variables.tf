variable "lambda_zip_files_bucket" {
  description = "This is the name of the s3 bucket where the code has uploaded"
}

variable "source_dir" {
  description = "Path to the function code"

}
variable "output_path" {
  description = "Path to the zip file of the function code"

}
variable "s3_bucket_key" {
  description = "Key value of the S3 bucket"

}
variable "function_name" {
  description = "Name of the lambda function"

}
variable "runtime" {
  description = "Lambda function runtime"

}
variable "memory_size" {
  description = "Lambda function memory size"

}
variable "handler" {
  description = "This is the lambda function handler"

}
variable "retention_in_days" {
  description = "How many days logs are there in the cloud watch logs"

}
variable "aws_lambda_permission_souce_arn" {
  description = "This is the lambda function source arn"

}
variable "aws_iam_role_lambda_name" {
  description = "This is the lambda role name"

}

variable "timeout" {
  description = "This is the timeout in seconds for the lambda function"

}
variable "managed_policy_name" {
  description = "This is the managed policy name for the lambda function"
}

variable "region" {
  description = "This is the region"
}
variable "statement_id" {
  description = "This is the invoke lambda statement id"
}
variable "action" {
  description = "This is the invoke lambda action"
}
variable "principal" {
  description = "This is the invoke lambda principal"
}


