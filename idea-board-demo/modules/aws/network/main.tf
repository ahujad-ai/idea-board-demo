variable "project_id" {}
variable "region" {}

resource "aws_vpc" "vpc" {
  cidr_block = "10.20.0.0/16"
}

output "network_id" {
  value = aws_vpc.vpc.id
}
