output "service_name" {
  value = try(kubernetes_service.default[0].metadata[0].name, null)
}

output "service_port" {
  value = try(kubernetes_service.default[0].spec[0].port[0].port, null)
}

output "host" {
  value = try("${kubernetes_service.default[0].metadata[0].name}.${var.namespace_name}.svc.cluster.local", null)
}
