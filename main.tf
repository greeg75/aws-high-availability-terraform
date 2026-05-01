module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = "10.0.0.0/16"
}

module "alb" {
  source         = "./modules/alb"
  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "compute" {
  source           = "./modules/compute"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnet    = module.vpc.public_subnets
  alb_sg_id        = module.alb.alb_sg_id
  target_group_arn = module.alb.target_group_arn
}