variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "region" {}
variable "vpc_id" {}

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

output "endpoint" {
  value = aws_db_instance.postgres.address
}
