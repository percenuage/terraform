variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "network_name" {
  type = string
}

variable "subnetwork_name" {
  type = string
}

/* LOCALS */

locals {
  project = "${var.namespace}-${var.env}"
}
