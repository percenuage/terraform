variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable region {
  type = string
}

variable zone {
  type = string
}

variable "subnetwork_cidr" {
  type = string
  description = "Subnetwork CIDR (ex. 10.0.0.0/16)"
}

/* LOCALS */

locals {}
