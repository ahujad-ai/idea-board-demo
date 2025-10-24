variable "cluster_name" {}
variable "region" {}
variable "network" {}

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = "" # Provide EKS Role ARN
  vpc_config {
    subnet_ids = [var.network]
  }
}

output "kubeconfig" {
  value = "TODO: generate kubeconfig"
}
