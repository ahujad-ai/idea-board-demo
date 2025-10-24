module "network" {
  source = "./modules/network"
  project_id = var.project_id
  region = var.region
}

module "gke" {
  source = "./modules/gke"
  cluster_name = "idea-board-cluster"
  region = var.region
  env = "dev"
  network = module.network.network_self_link
  subnetwork   = module.network.subnet_self_link
}

module "cloudsql" {
  source = "./modules/cloudsql"
  instance_name = "idea-board-db"
  db_name = "ideas"
  db_user = "postgres"
  db_password = var.db_password
  region = var.region
}


resource "google_artifact_registry_repository" "idea_repo" {
  provider          = google
  project           = var.project_id
  location          = var.region
  repository_id     = "idea-board"
  description       = "Artifact Registry for Idea Board Docker images"
  format            = "DOCKER"
}

data "google_project" "current" {
  project_id = var.project_id
}

# 1️⃣ Default GKE nodepool robot account
locals {
  gke_node_sa = "service-${data.google_project.current.number}@container-engine-robot.iam.gserviceaccount.com"
  compute_sa  = "service-${data.google_project.current.number}@compute-system.iam.gserviceaccount.com"
}

# 2️⃣ Grant Cloud SQL access to both (safe, idempotent)
resource "google_project_iam_member" "gke_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${local.gke_node_sa}"
}

resource "google_project_iam_member" "compute_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${local.compute_sa}"
}
