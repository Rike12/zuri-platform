terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket       = "zuri-market-terraform-state-123515104957"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  name                 = "zuri"
  environment          = "dev"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}
module "security_groups" {
  source = "../../modules/security-groups"

  name        = "zuri"
  environment = "dev"
  vpc_id      = module.vpc.vpc_id
  admin_cidr  = var.admin_cidr
}
module "compute" {
  source = "../../modules/compute"

  name              = "zuri"
  environment       = "dev"
  instance_type     = var.instance_type
  key_name          = "my-key"
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_groups.k3s_security_group_id
  user_data         = file("${path.module}/../../scripts/install-k3s.sh")
}
