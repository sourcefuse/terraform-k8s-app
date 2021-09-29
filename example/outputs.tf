output "kubernetes_service_name" {
  value = module.example["nginx"].service_name
}

output "kubernetes_service_port" {
  value = module.example["nginx"].service_port
}

output "kubernetes_host" {
  value = module.example["nginx"].host
}

output "kubernetes_namespace" {
  value = kubernetes_namespace.this.metadata[0].name
}
