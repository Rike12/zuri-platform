output "vpc_id" {
  description = "ID of the production VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the production public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the production private subnets"
  value       = module.vpc.private_subnet_ids
}
