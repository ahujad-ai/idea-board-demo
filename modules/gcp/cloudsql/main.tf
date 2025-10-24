variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "region" {}

resource "google_sql_database_instance" "postgres" {
  name             = "idea-postgres"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "db" {
  name     = var.db_name
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}

output "connection_string" {
  value = "postgresql://${var.db_user}:${var.db_password}@${google_sql_database_instance.postgres.public_ip_address}:5432/${var.db_name}"
}
