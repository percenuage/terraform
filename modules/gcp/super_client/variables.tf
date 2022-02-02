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
  default = []
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

variable "iam_role_condition" {
  type = string
  default = ""
}

variable "iam_role_name" {
  type = string
}

variable "clients" {
  type = list(string)
}

/* LOCALS */

locals {
  project = "${var.namespace}-${var.env}"
  service_accounts = formatlist("${var.namespace}-%s", var.clients)
  bucket_names = [
    for pair in setproduct(var.clients, var.bucket_names) : join("-", pair)
  ]
  bucket_lifecycle = merge(flatten([
    for client in var.clients : [
      for bucket, age in var.bucket_lifecycle : { "${client}-${bucket}" = age }
    ]
  ])...)
  bucket_viewers = merge(flatten([
    for client in var.clients : [
      for bucket, members in var.bucket_viewers : { "${client}-${bucket}" = members }
    ]
  ])...)
  bucket_creators = merge(flatten([
    for client in var.clients : [
      for bucket, members in var.bucket_creators : { "${client}-${bucket}" = members }
    ]
  ])...)
}
