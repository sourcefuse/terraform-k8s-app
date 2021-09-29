locals {
  apps = {
    nginx = {
      app_label             = var.nginx_name
      container_image       = "nginx:alpine"
      container_name        = var.nginx_name
      container_port        = 80
      deployment_name       = var.nginx_name
      namespace_name        = var.namespace
      port                  = 80
      port_name             = "80"
      protocol              = "TCP"
      service_name          = var.nginx_name
      target_port           = 80
      replica_count         = 1
      environment_variables = []

      ## pvc
      persistent_volume_claim_enable           = false
      persistent_volume_claim_name             = "${var.nginx_name}-pvc"
      persistent_volume_claim_labels           = tomap({ "io.sourceloop.service" = var.nginx_name })
      persistent_volume_claim_namespace        = var.namespace
      persistent_volume_claim_resource_request = tomap({ storage = "100Mi" })

      ## config maps
      config_map_enabled     = false
      config_map_binary_data = {}
      config_map_data        = {}
      config_map_name        = ""

      ## secrets
      secret_enable      = false
      secret_annotations = {}
      secret_data        = {}
      secret_labels      = {}
      secret_name        = "${var.nginx_name}-secret"
      secret_namespace   = var.namespace
      secret_type        = ""
    }
  }
}
