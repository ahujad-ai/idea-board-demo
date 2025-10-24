output "kubeconfig" {
  value     = module.k8s.kubeconfig
  sensitive = true
}

output "db_connection_string" {
  value     = module.db.connection_string
  sensitive = true
}
