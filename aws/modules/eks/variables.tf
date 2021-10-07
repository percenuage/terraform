variable "aws_region" {
  type = string
  default = "eu-west-3"
  description = "The aws region name."
}

variable "aws_ssh_key_name" {
  type = string
  default = "agendillard@aws-percenuage"
  description = "The name of ssh key."
}

variable "ssh_private_key_filename" {
  type = string
  default = "~/.ssh/aws_percenuage_agendillard_rsa"
  description = "The name of local private ssh key."
}

variable "instance_type" {
  type = string
  default = "t3a.small"
  description = "The type of rancher instance."
}

variable "domain" {
  type = string
  default = "percenuage.com"
  description = "The domaine name. (ex. percenuage.com)"
}

variable "namespace" {
  type = string
  default = "percenuage"
  description = "The namespace of VPC. ($NAMESPACE-$ENV-xxx)"
}

variable "env" {
  type = string
  description = "The env of the VPC. [prod|staging|dev]"
}

/* LOCALS */

locals {
  prefixed_domain = var.env == "prod" ? var.domain : "${var.env}.${var.domain}"
  name = "${var.namespace}-${var.env}"
}
