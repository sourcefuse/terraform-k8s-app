###########################################
## defaults / versions / providers
###########################################
terraform {
  required_version = ">= 1.4.4"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
