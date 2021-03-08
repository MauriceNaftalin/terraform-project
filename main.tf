provider "aws" {
  version = "2.12.0"
  region = "eu-west-2"
  profile = "manningproject"
}
 
module "networking" {
  source = "./modules/networking"
  namespace = var.namespace
}

module "instances" {
  source = "./modules/instances"
  namespace = var.namespace
  sg = module.networking.sg
  subnet_ids = module.networking.subnet_ids
}
