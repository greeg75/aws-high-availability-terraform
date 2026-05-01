module "vpc"{
    source = "./modules/vpc"
    project_name = "project-high-availability"
    vpc_cidr = "10.0.0.0/16"
}