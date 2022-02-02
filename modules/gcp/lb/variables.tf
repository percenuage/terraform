variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "domain" {
  type = string
}

variable "subdomains" {
  type = list(string)
}

/* LOCALS */

locals {
  hosts = formatlist(var.env == "prod" ? "%s.${var.domain}" : "%s.${var.env}.${var.domain}", var.subdomains)
}
