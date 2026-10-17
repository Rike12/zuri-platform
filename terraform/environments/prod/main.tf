terraform {
  backend "s3" {
    bucket       = "zuri-market-terraform-state-123515104957"
    key          = "prod/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  name                 = "zuri"
  environment          = "prod"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security_groups" {
  source = "../../modules/security-groups"

  name        = "zuri"
  environment = "prod"
  vpc_id      = module.vpc.vpc_id
  admin_cidr  = var.admin_cidr
}
