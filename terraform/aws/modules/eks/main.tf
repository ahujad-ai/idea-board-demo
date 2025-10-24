variable "cluster_name" {}
variable "region" {}
variable "vpc_id" {}

resource "aws_eks_cluster" "eks" {
  name = var.cluster_name
  role_arn = "" # Fill with a proper IAM role ARN for EKS
  vpc_config {
    subnet_ids = [var.vpc_id]
  }
}

output "kubeconfig" {
  value = "TODO: generate kubeconfig via aws eks update-kubeconfig"
}
