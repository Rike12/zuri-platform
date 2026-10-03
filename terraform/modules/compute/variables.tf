variable "name" {
  description = "Name prefix for the EC2 instance."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the k3s host will run."
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the k3s host."
  type        = string
}

variable "user_data" {
  description = "Cloud-init/user-data script for the instance."
  type        = string
  default     = null
}
variable "key_name" {
  description = "EC2 key pair name for SSH access."
  type        = string
}
