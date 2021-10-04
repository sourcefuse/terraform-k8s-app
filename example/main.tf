## set the provider
provider "kubernetes" {
  config_path = var.k8s_config_path
}

## create the namespace
resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

## create the cluster resources
module "example" {
  source   = "../"
  for_each = local.apps

  app_label       = each.value.app_label
  container_image = each.value.container_image
  container_name  = each.value.container_name
  container_port  = each.value.container_port
  deployment_name = each.value.deployment_name
  namespace_name  = each.value.namespace_name
  port            = each.value.port
  port_name       = each.value.port_name
  protocol        = each.value.protocol
  service_name    = each.value.service_name
  target_port     = each.value.target_port
  replica_count   = each.value.replica_count

  environment_variables = each.value.environment_variables

  ## pvc
  persistent_volume_claim_enable           = try(each.value.persistent_volume_claim_enable, false)
  persistent_volume_claim_labels           = try(each.value.persistent_volume_claim_labels, {})
  persistent_volume_claim_name             = try(each.value.persistent_volume_claim_name, null)
  persistent_volume_claim_namespace        = try(each.value.persistent_volume_claim_namespace, null)
  persistent_volume_claim_resource_request = try(each.value.persistent_volume_claim_resource_request, {})

  ## config maps
  config_map_enabled     = each.value.config_map_enabled
  config_map_binary_data = try(each.value.config_map_binary_data, {})
  config_map_data        = try(each.value.config_map_data, {})
  config_map_name        = try(each.value.config_map_name, null)

  ## secrets
  secret_enable      = each.value.secret_enable
  secret_annotations = try(each.value.secret_annotations, {})
  secret_data        = try(each.value.secret_data, {})
  secret_labels      = try(each.value.secret_labels, {})
  secret_name        = try(each.value.secret_name, null)
  secret_namespace   = try(each.value.secret_namespace, null)
  secret_type        = try(each.value.secret_type, null)
}
