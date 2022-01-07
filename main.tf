module "network" {
  source   = "./network"
  region   = var.region
  vpc_cidr = var.vpc_cidr
  tags  = {
    prakash = "jha"
  }
}

module "ec2" {
  source            = "./ec2"
  vpc_id            = module.network.vpc_id
  alb_subnet_ids    = module.network.public_subnet_ids
  team_name         = var.team_name
  private_subnet_id = module.network.private_subnet_ids[0]
  nat_gw_id         = module.network.nat_gateway_id
  region            = var.region
}

