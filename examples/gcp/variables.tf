variable region {
  type = string
  default = "europe-west1"
}

variable zone {
  type = string
  default = "europe-west1-c"
}

variable "env" {
  type = string
  default = "dev"
}

variable "namespace" {
  type = string
  default = "percenuage"
}

/* LOCALS */

locals {
  project = "${var.namespace}-${var.env}"
}
