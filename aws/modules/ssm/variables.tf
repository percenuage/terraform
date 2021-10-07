variable "aws_region" {
  type = string
  default = "eu-west-3"
  description = "The aws region name."
}

variable "user" {
  type = string
  default = "supertec"
  description = "User name of the public key."
}

variable "env" {
  type = string
  description = "The env of the VPC. [prod|staging|test|dev]"
}

/* LOCALS */

locals {
  path = "/${var.env}/srv/ssh"
}
