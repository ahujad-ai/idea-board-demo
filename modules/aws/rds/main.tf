variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "region" {}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t3.micro"
  name                 = var.db_name
  username             = var.db_user
  password             = var.db_password
  skip_final_snapshot  = true
}

output "connection_string" {
  value = "postgresql://${var.db_user}:${var.db_password}@${aws_db_instance.postgres.address}:5432/${var.db_name}"
}
