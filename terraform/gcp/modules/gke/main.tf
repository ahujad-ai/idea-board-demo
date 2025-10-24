variable "cluster_name" {}
variable "region" {}
variable "network" {}

variable "subnetwork" {
  description = "Subnetwork self link"
  type        = string
}

variable "env" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
}

# 👇 GKE cluster without the default node pool
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.4.0.0/14"
    services_ipv4_cidr_block = "10.8.0.0/20"
  }

  network     = var.network
  subnetwork  = var.subnetwork
  deletion_protection = false

  # 👇 Don't create a default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    disk_type    = "pd-standard"
    disk_size_gb = 30
  }
}

# 👇 Create a single node pool with 1 node
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name

  node_count = 1  # 👈 only one node total

  node_config {
    preemptible  = false
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    labels = {
      env = var.env
    }
    tags = ["gke-node"]
  }

  depends_on = [google_container_cluster.primary]
}

output "endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "kubeconfig" {
  value = <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${google_container_cluster.primary.master_auth[0].cluster_ca_certificate}
    server: https://${google_container_cluster.primary.endpoint}
  name: ${var.cluster_name}
contexts:
- context:
    cluster: ${var.cluster_name}
    user: ${var.cluster_name}
  name: ${var.cluster_name}
current-context: ${var.cluster_name}
kind: Config
preferences: {}
users:
- name: ${var.cluster_name}
  user:
    auth-provider:
      name: gcp
EOF
  sensitive = true
}