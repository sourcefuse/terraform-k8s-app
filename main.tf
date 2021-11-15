resource "kubernetes_service" "default" {
  metadata {
    name      = var.service_name
    namespace = var.namespace_name

    labels = {
      app : var.app_label
    }
  }

  spec {
    port {
      name        = var.port_name
      port        = var.port
      target_port = var.target_port
      protocol    = var.protocol
    }

    selector = {
      app : var.app_label
    }
  }
}

resource "kubernetes_deployment" "default" {
  metadata {
    name      = var.deployment_name
    namespace = var.namespace_name

    labels = {
      app : var.app_label
    }
  }
  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app : var.app_label
      }
    }

    template {
      metadata {
        namespace = var.namespace_name

        labels = {
          app : var.app_label
        }
      }

      spec {
        container {
          name  = var.container_name
          image = var.container_image

          port {
            container_port = var.container_port
          }

          dynamic "env" {
            iterator = environment_variable
            for_each = var.environment_variables

            content {
              name  = environment_variable.value["name"]
              value = environment_variable.value["value"]
            }
          }

          dynamic "env_from" {
            iterator = secrets
            for_each = local.secret_names
            content {
              secret_ref {
                name = secrets.key
              }
            }
          }

        }
      }
    }
  }
}

locals {
  secret_names = [try(kubernetes_secret.default.metadata[0].name, [])]
}

## pv and pvc
resource "kubernetes_persistent_volume" "default" {
  count = var.persistent_volume_enable == true ? 1 : 0

  metadata {
    name        = var.persistent_volume_name
    annotations = var.persistent_volume_annotations
    labels      = var.persistent_volume_labels
  }

  // TODO - remove hardcoded values

  spec {
    access_modes                     = var.persistent_volume_access_modes
    persistent_volume_reclaim_policy = var.persistent_volume_reclaim_policy

    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"

            values = [
              "localhost"
            ]
          }
        }
      }
    }

    capacity = {
      storage = var.persistent_volume_storage_size
    }

    persistent_volume_source {
      local {
        path = var.persistent_volume_storage_path
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "default" {
  count = var.persistent_volume_claim_enable == true ? 1 : 0

  metadata {
    name        = var.persistent_volume_claim_name
    annotations = var.persistent_volume_claim_annotations
    labels      = var.persistent_volume_claim_labels
    namespace   = var.persistent_volume_claim_namespace
  }

  spec {
    access_modes       = var.persistent_volume_claim_access_modes
    volume_name        = try(kubernetes_persistent_volume.default[0].metadata.0.name, var.persistent_volume_claim_volume_name)
    storage_class_name = var.persistent_volume_claim_storage_class_name

    resources {
      limits   = var.persistent_volume_claim_resource_limits
      requests = var.persistent_volume_claim_resource_request
    }
  }
}

## secrets
resource "kubernetes_secret" "default" {
  count = var.secret_enable == true ? 1 : 0

  data = var.secret_data
  type = var.secret_type

  metadata {
    annotations = var.secret_annotations
    labels      = var.secret_labels
    name        = var.secret_name
    namespace   = var.secret_namespace
  }
}

## config maps
resource "kubernetes_config_map" "default" {
  count = var.config_map_enabled == true ? 1 : 0

  data        = try(var.config_map_data, {})
  binary_data = try(var.config_map_binary_data, {})

  metadata {
    name        = var.config_map_name
    annotations = var.persistent_volume_claim_annotations
    labels      = var.persistent_volume_claim_labels
    namespace   = var.persistent_volume_claim_namespace
  }
}
