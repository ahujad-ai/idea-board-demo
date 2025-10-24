variable "project_id" {}
variable "region" {}

# 🐳 Create an Artifact Registry for Docker images
resource "google_artifact_registry_repository" "idea_repo" {
  provider          = google
  project           = var.project_id
  location          = var.region
  repository_id     = "idea-board"
  description       = "Artifact Registry for Idea Board Docker images"
  format            = "DOCKER"
  cleanup_policy_dry_run = true
}
