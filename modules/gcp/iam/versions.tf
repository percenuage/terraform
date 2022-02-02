terraform {
  required_version = "1.1.4"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.7.0"
    }
  }
}
