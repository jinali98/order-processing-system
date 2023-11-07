variable "region" {
  description = "This is the cloud hosting region where the webapp will be deployed."
  default     = "ap-south-1"
}

variable "prefix" {
  description = "This is the environment where the webapp is deployed."
  default     = "dev"
}
variable "profile" {
  description = "This is the user profile for aws cred"
  default = "jinali"
}

