variable "aws_region" {
  description = "AWS region for the environment"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}
variable "admin_cidr" {
  description = "CIDR block allowed to access the EC2 host over SSH."
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type for the k3s host."
  type        = string
  default     = "t3.small"
}

variable "user_data" {
  description = "User-data script used to bootstrap k3s."
  type        = string
  default     = null
}
