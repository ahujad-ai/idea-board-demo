terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  
  # Skip auth for dry-run mode
  skip_credentials_validation = true
  skip_provider_registration  = true
}
