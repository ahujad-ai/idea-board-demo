output "kubeconfig" {
  value = module.eks.kubeconfig
  sensitive = true
}

output "rds_endpoint" {
  value = module.rds.endpoint
}
