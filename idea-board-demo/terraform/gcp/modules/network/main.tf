variable "project_id" {}
variable "region" {}

resource "google_compute_network" "vpc" {
  name                    = "idea-board-vpc"
  auto_create_subnetworks = false
  project = var.project_id
}

resource "google_compute_subnetwork" "subnet" {
  name          = "idea-board-subnet"
  ip_cidr_range = "10.10.0.0/20"
  region        = var.region
  network       = google_compute_network.vpc.self_link
  project       = var.project_id
}

output "subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}

output "network_self_link" {
  value = google_compute_network.vpc.self_link
}
