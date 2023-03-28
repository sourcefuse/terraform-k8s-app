variable "namespace" {
  type    = string
  default = "terratest"
}

variable "nginx_name" {
  type    = string
  default = "nginx"
}

variable "k8s_config_path" {
  type    = string
  default = "~/.kube/config"
}
