resource "kubernetes_service" "default" {
  count = var.enable_kubernetes_service == true ? 1 : 0

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

resource "time_sleep" "create_config" {
  depends_on = [
    kubernetes_config_map.default,
    kubernetes_secret.default
  ]

  create_duration = "30s"
}

resource "kubernetes_deployment" "default" {

  depends_on = [
    time_sleep.create_config
  ]

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
        service_account_name = var.service_account_name

        dynamic "volume" {
          for_each = var.csi_secret_volumes
          iterator = csi_secret_volume
          content {
            name = lookup(csi_secret_volume.value, "volume_name", null)
            csi {
              read_only         = lookup(csi_secret_volume.value, "read_only", null)
              driver            = lookup(csi_secret_volume.value, "driver", null)
              volume_attributes = lookup(csi_secret_volume.value, "volume_attributes", null)
              
            }
          }
        }

        container {
          name  = var.container_name
          image = var.container_image

          dynamic "resources" {
            for_each = { for n in { name = "resource" } : n => n if var.container_resources_enabled == true }

            content {
              limits   = var.container_resources_limits
              requests = var.container_resources_requests
            }
          }

          dynamic "volume_mount" {
            for_each = var.csi_secret_volumes
            iterator = csi_secret_volume

            content {
              name       = lookup(csi_secret_volume.value, "volume_name", null)
              mount_path = lookup(csi_secret_volume.value, "mount_path", null)
              read_only  = lookup(csi_secret_volume.value, "read_only", null)
            }
          }

          dynamic "port" {
            for_each = {
              for port in tomap({ port = var.container_port }) : port => port
              if var.container_port != null
            }

            content {
              container_port = port.value
            }
          }

          dynamic "env" {
            iterator = environment_variable
            for_each = var.environment_variables

            content {
              name  = lookup(environment_variable.value, "name", null)
              value = lookup(environment_variable.value, "value", null)
            }
          }

          dynamic "env" {
            iterator = env_secret_key_ref
            for_each = var.env_secret_refs
            content {
              name = lookup(env_secret_key_ref.value, "env_var_name", null)
              value_from {
                secret_key_ref {
                  name = lookup(env_secret_key_ref.value, "secret_key_ref_name", null)
                  key  = lookup(env_secret_key_ref.value, "secret_key_ref_key", null)
                }
              }
            }
          }
        }
      }
    }
  }
}

## pv and pvc
## TODO: clean this up
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

    // TODO: make dynamic based off of input variable
    persistent_volume_source {
      ####----------------- SECRETS -----------------####
      csi {
        driver        = var.persistent_volume_secrets_driver
        volume_handle = null
        volume_attributes = {
          secretProviderClass : var.persistent_volume_secret_provider_class
        }
      }
      ####----------------- SECRETS -----------------####

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
    volume_name        = try(kubernetes_persistent_volume.default[0].metadata[0].name, var.persistent_volume_claim_volume_name)
    storage_class_name = var.persistent_volume_claim_storage_class_name

    resources {
      limits   = var.persistent_volume_claim_resource_limits
      requests = var.persistent_volume_claim_resource_request
    }
  }
}

## secrets
## TODO: should this be created outside of this module. When would we use it?
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
