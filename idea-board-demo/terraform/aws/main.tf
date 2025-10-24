module "network" {
  source = "./modules/network"
  region = var.region
}

module "eks" {
  source = "./modules/eks"
  cluster_name = "idea-board-cluster"
  region = var.region
  vpc_id = module.network.vpc_id
}

module "rds" {
  source = "./modules/rds"
  db_name = "ideas"
  db_user = "postgres"
  db_password = var.db_password
  region = var.region
  vpc_id = module.network.vpc_id
}
