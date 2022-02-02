variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable "custom_roles" {
  type = map(any)
  default = {}
}

variable "members" {
  type = map(any)
  default = {}
}

variable "service_accounts" {
  type = map(any)
}

/* LOCALS */

locals {
  project = "${var.namespace}-${var.env}"
  member_role_pairs = flatten(concat(
    [
      for member, roles in var.members : [
        for role in roles : { role = role, member = member }
      ]
    ],
    [
      for id, roles in var.service_accounts : [
        for role in roles : { role = role, member = "serviceAccount:${google_service_account.sa[id].email}" }
      ]
    ]
  ))
}
