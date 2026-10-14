variable "name" {
  description = "Project name used to name IAM resources."
  type        = string
}

variable "environment" {
  description = "Environment name, such as dev or prod."
  type        = string
}
