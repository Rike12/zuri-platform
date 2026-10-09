variable "name" {
  description = "Name prefix for security group resources."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC."
  type        = string
}

variable "admin_cidr" {
  description = "CIDR block allowed to access the EC2 host over SSH."
  type        = string
}
