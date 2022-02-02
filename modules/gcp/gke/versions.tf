terraform {
  required_version = "1.1.4"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.72"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.72"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 1.13.3"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 1.3.2"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.0.0"
    }
  }
}
