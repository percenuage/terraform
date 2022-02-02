variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable "domain" {
  type = string
}

variable "subdomains" {
  type = list(string)
}

variable "clients" {
  type = list(string)
}

variable "client_subdomains" {
  type = list(string)
}

/* LOCALS */

locals {
  project = "${var.namespace}-${var.env}"
  host_clients = formatlist("%s.${var.domain}", var.clients)
  host_client_subdomains = flatten([
    for i in var.clients: [
      for j in var.client_subdomains: "${j}.${i}.${var.domain}"
  ]])
  host_subdomains = formatlist("%s.${var.domain}", var.subdomains)
  hosts = concat(local.host_clients, local.host_client_subdomains, local.host_subdomains)
}
