variable "cluster_name" {}
variable "region" {}
variable "network" {}

resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region
  network  = var.network

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.gke.name
  location   = var.region
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

output "kubeconfig" {
  value = "TODO: generate kubeconfig"
}
