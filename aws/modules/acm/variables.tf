variable "aws_region" {
  type = string
  default = "eu-west-3"
  description = "The aws region name."
}

variable "domains" {
  type = list(string)
  default = ["percenuage-dev.com"]
  description = "The domaine list."
}

variable "env" {
  type = string
  description = "The env of the VPC. [prod|staging|test|dev]"
}

/* LOCALS */

locals {
  subdomain = var.env == "prod" ? "*" : "*.${var.env}"
}
