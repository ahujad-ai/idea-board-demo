module "network" {
  source = var.cloud == "gcp" ? "./modules/gcp/network" : "./modules/aws/network"
  project_id = var.project_id
  region     = var.region
}

module "k8s" {
  source       = var.cloud == "gcp" ? "./modules/gcp/gke" : "./modules/aws/eks"
  cluster_name = var.cluster_name
  region       = var.region
  network      = module.network.network_id
}

module "db" {
  source = var.cloud == "gcp" ? "./modules/gcp/cloudsql" : "./modules/aws/rds"
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
  region      = var.region
}