resource "aws_vpc" "vpc" {
  cidr_block = "10.20.0.0/16"
  tags = { Name = "idea-board-vpc" }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
