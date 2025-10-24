variable "cloud" {
  type    = string
  default = "gcp"
  description = "Cloud provider: gcp or aws"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  count   = var.cloud == "gcp" ? 1 : 0
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  count      = var.cloud == "aws" ? 1 : 0
}
