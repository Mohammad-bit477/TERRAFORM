provider "aws" {
  region = var.region
}

module "vpc" {
  source              = "./modules/vpc"
  project             = var.project
  vpc_cidr            = var.vpc_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az                  = var.az
}

module "s3" {
  source = "./modules/s3"

  project                = var.project
  region                 = var.region
  vpc_id                 = module.vpc.vpc_id
  private_route_table_ids = [module.vpc.private_route_table_id]
  tags                   = {
    Environment = "dev"
    Project     = var.project
  }
}


module "ec2" {
  source               = "./modules/ec2"
  project              = var.project
  instance_type        = var.instance_type
  ec2_ami              = var.ec2_ami
  private_subnet_id    = module.vpc.private_subnet_id
  vpc_id               = module.vpc.vpc_id
}
