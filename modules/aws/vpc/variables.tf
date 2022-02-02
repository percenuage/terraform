variable "aws_region" {
  type = string
  default = "eu-west-3"
  description = "The aws region name."
}

variable "enable_s3_logs" {
  type = bool
  default = false
  description = "Enable logs in creating S3 bucket."
}

variable "namespace" {
  type = string
  description = "The namespace of VPC. ($NAMESPACE-$ENV-vpc)"
}

variable "env" {
  type = string
  description = "The env of the VPC. [prod|staging|dev|...]"
}

variable "index" {
  type = number
  description = "The X number for the VPC's cidr. (10.X.0.0/16)"
}

/* LOCALS */

locals {
  name = "${var.namespace}-${var.env}"
  zones = ["a", "b", "c"]
  subnet_count = 3
}
