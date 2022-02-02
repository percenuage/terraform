provider "google" {
  project = local.project
  region = var.region
  zone = var.zone
}

provider "google-beta" {
  project = local.project
  region = var.region
  zone = var.zone
}

provider "kubernetes" {}

terraform {
  backend "gcs" {
    bucket = "percenuage-infra"
    prefix = "terraform/state/dev/"
  }
}
