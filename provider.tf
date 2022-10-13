###########################################
## defaults / versions / providers
###########################################
terraform {
  required_version = ">= 1.0.8"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.1"
    }

    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.2"
    }
  }
}