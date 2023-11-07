variable "rest_api_name" {
  description = "This is the name of the API gateway"
  default     = "event-driven-ecom-system"
}

variable "rest_api_stage_name" {
  description = "This is the API Gateway stage (dev, prod, stg)"
  default     = "dev"
}

variable "api_description" {
  description = "Description of the API"
  default     = "API Gateway for the event driven ecom system"
}


variable "retention_in_days" {
  description = "How Long logs are gonna be in the cloud watch group"
  default     = 14
}

variable "prefix" {
  description = "the prefix of the environment"
  default     = "dev"

}

variable "region" {
  description = "this is the aws region"
  default     = "ap-south-1"
}

variable "profile" {
  description = "profile to use"
  default     = "jinali"
}
