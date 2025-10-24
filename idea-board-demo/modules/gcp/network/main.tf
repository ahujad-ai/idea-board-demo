variable "project_id" {}
variable "region" {}

resource "google_compute_network" "vpc" {
  name                    = "idea-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "idea-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

output "network_id" {
  value = google_compute_network.vpc.id
}
