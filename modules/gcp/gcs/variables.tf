variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable "location" {
  type = string
}

variable "bucket_names" {
  type = list(string)
}

variable "bucket_viewers" {
  type = map(any)
  default = {}
}

variable "bucket_creators" {
  type = map(any)
  default = {}
}

variable "bucket_lifecycle" {
  type = map(any)
  description = "Simple delete object lifecycle with age conditional in day"
  default = {}
}

/* LOCALS */

locals {
  project = "${var.namespace}-${var.env}"
}
