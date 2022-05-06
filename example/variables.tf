variable "namespace" {
  default = "terratest"
}

variable "nginx_name" {
  default = "nginx"
}

variable "k8s_config_path" {
  default = "~/.kube/config"
}
