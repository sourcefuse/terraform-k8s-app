variable "enable_kubernetes_service" {
  description = "Enable the kubernetes service."
  type        = bool
  default     = true
}

variable "service_name" {
  type        = string
  description = "Name of the k8s service"
}

variable "namespace_name" {
  type        = string
  description = "Name of the k8s namespace"
}

variable "app_label" {
  type        = string
  description = "Value for the app label used for label matching"
}

variable "port_name" {
  type        = string
  description = "Name of the service port"
}

variable "port" {
  type        = number
  description = "k8s service port"
}

variable "target_port" {
  type        = number
  description = "k8s service target port"
}

variable "protocol" {
  type        = string
  description = "k8s service protocol"
}

variable "deployment_name" {
  type        = string
  description = "Name of the k8s deployment"
}

variable "container_name" {
  type        = string
  description = "Name of container for the k8s deployment"
}

variable "container_image" {
  type        = string
  description = "Docker image for the k8s deployment"
}

variable "container_port" {
  type        = number
  description = "Container port for the k8s deployment"
}

variable "container_resources_enabled" {
  type        = bool
  description = "Enable container resource limits / requests."
  default     = false
}

variable "container_resources_limits" {
  type = object({
    cpu    = string
    memory = string
  })
  description = "Describes the maximum amount of compute resources allowed. For more info see http://kubernetes.io/docs/user-guide/compute-resources"
  default = {
    cpu    = "0.5"
    memory = "512Mi"
  }
}

variable "container_resources_requests" {
  type = object({
    cpu    = string
    memory = string
  })
  description = "Describes the minimum amount of compute resources required."
  default = {
    cpu    = "250m"
    memory = "50Mi"
  }
}

variable "replica_count" {
  type        = number
  description = "k8s Deployment replica count"
}

variable "environment_variables" {
  description = "List of maps for environment variables"
  type        = list(object({ name = string, value = string }))
  default     = []
}

variable "csi_secret_volumes" {
  description = "List of maps of CSI volumes. These are used to dynamically generate the volume specs."
  type = list(object({
    volume_name = string,
    mount_path  = string,
    read_only   = bool,
    driver      = string,
    volume_attributes = object({
      secretProviderClass = string
    })
  }))
  default = []
}


variable "env_secret_refs" {
  description = "List of secretKeyRefs to add to ENV variables."
  type = list(object({
    env_var_name        = string,
    secret_key_ref_name = string,
    secret_key_ref_key  = string
  }))
  default = []
}
####################################################
## persistent volume and claims
####################################################
## pv
variable "persistent_volume_annotations" {
  description = "An unstructured key value map stored with the persistent volume that may be used to store arbitrary metadata."
  type        = map(any)
  default     = {}
}

variable "persistent_volume_access_modes" {
  description = "Contains all ways the volume can be mounted. Valid values are ReadWriteOnce, ReadOnlyMany, ReadWriteMany."
  type        = list(string)
  default     = ["ReadWriteMany"]
}

variable "persistent_volume_enable" {
  description = "Enable a persistent volume."
  type        = bool
  default     = false
}

variable "persistent_volume_labels" {
  description = "Map of string keys and values that can be used to organize and categorize (scope and select) the persistent volume. May match selectors of replication controllers and services."
  type        = map(any)
  default     = {}
}

variable "persistent_volume_name" {
  description = "Name of the persistent volume, must be unique. Cannot be updated."
  type        = string
  default     = null
}

variable "persistent_volume_reclaim_policy" {
  description = "What happens to a persistent volume when released from its claim. Valid options are Retain (default), Delete and Recycle. Recycling must be supported by the volume plugin underlying this persistent volume."
  type        = string
  default     = "Delete"
}

# variable "persistent_volume_storage_path" {
#   description = "Path of the directory on the host."
#   type = string
#   default     = null
# }

variable "persistent_volume_storage_size" {
  description = "Persistent volume size."
  type        = string
  default     = "1Gi"
}

## pvc
variable "persistent_volume_claim_access_modes" {
  description = "A set of the desired access modes the volume should have."
  type        = list(string)
  default     = ["ReadWriteMany"]
}

variable "persistent_volume_claim_annotations" {
  description = "An unstructured key value map stored with the persistent volume claim that may be used to store arbitrary metadata."
  type        = map(any)
  default     = {}
}

variable "persistent_volume_claim_enable" {
  description = "Enable a persistent volume claim."
  type        = bool
  default     = false
}

variable "persistent_volume_claim_labels" {
  description = "Map of string keys and values that can be used to organize and categorize (scope and select) the persistent volume claim. May match selectors of replication controllers and services."
  type        = map(any)
  default     = {}
}

variable "persistent_volume_claim_name" {
  description = "Name of the persistent volume claim, must be unique. Cannot be updated."
  type        = string
  default     = null
}

variable "persistent_volume_claim_namespace" {
  description = "Namespace defines the space within which name of the persistent volume claim must be unique."
  type        = string
  default     = null
}

variable "persistent_volume_claim_volume_name" {
  description = "The binding reference to the PersistentVolume backing this claim."
  type        = string
  default     = null
}

variable "persistent_volume_claim_resource_limits" {
  description = "Map describing the maximum amount of compute resources allowed."
  type        = map(string)
  default     = {}
}

variable "persistent_volume_claim_resource_request" {
  description = "Map describing the minimum amount of compute resources required."
  type        = map(string)

  default = {
    storage = "5Gi"
  }
}

variable "persistent_volume_claim_storage_class_name" {
  description = "Name of the storage class requested by the claim."
  type        = string
  default     = null
}

// TODO: determine if these are needed right now
# variable "persistent_volume_claim_storage_size" {
#   description = "Map describing the minimum amount of compute resources required."
#   type = map(any)
#   default     = null
# }

variable "persistent_volume_secrets_driver" {
  description = "Driver for persistent volume. Defaults to CSI driver setting"
  default     = "secrets-store.csi.k8s.io"
  type        = string
}

variable "persistent_volume_secret_provider_class" {
  description = "Name of the secret provider class for CSI driver volume mounts for secret"
  type        = string
  default     = null
}

# variable "persistent_volume_mount_path" {
#   description = "Path to mount the persistent volume for secrets"
#   default     = "/mnt/secrets-store"
#   type        = string
# }
####################################################
## secrets
####################################################
variable "secret_annotations" {
  description = "An unstructured key value map stored with the secret that may be used to store arbitrary metadata."
  type        = map(any)
  default     = null
}

variable "secret_data" {
  description = "A map of the secret data."
  type        = map(any)
  default     = {}
}

variable "secret_enable" {
  description = "Enable Kubernetes secrets resource."
  type        = bool
  default     = false
}

variable "secret_labels" {
  description = "Map of string keys and values that can be used to organize and categorize (scope and select) the secret."
  type        = map(any)
  default     = {}
}

variable "secret_name" {
  description = "Name of the secret, must be unique. Cannot be updated."
  type        = string
  default     = null
}

variable "secret_namespace" {
  description = "Namespace defines the space within which name of the secret must be unique."
  type        = string
  default     = null
}

variable "secret_type" {
  description = "The secret type. Defaults to Opaque. See https://kubernetes.io/docs/concepts/configuration/secret/#secret-types for the different types."
  type        = string
  default     = "Opaque"
}

variable "service_account_name" {
  description = "Name of the service account to be used for this deployment."
  type        = string
  default     = null
}

####################################################
## config maps
####################################################
variable "config_map_binary_data" {
  description = "Map of binary data for the config map."
  type        = map(any)
  default     = {}
}

variable "config_map_data" {
  description = "Map of data for the config map."
  type        = map(any)
  default     = {}
}

variable "config_map_enabled" {
  description = "Enable the Kubernetes config map."
  type        = bool
  default     = false
}

variable "config_map_name" {
  description = "Name to give the config map."
  type        = string
  default     = null
}
