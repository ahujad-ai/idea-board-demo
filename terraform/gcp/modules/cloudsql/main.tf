variable "instance_name" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "region" {}

resource "google_sql_database_instance" "postgres" {
  name             = var.instance_name
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

resource "google_sql_user" "postgres_user" {
  name     = var.db_user
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}

output "connection_name" {
  value = google_sql_database_instance.postgres.connection_name
}
