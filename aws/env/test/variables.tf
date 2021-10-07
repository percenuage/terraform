variable "aws_region" {
  type = string
  default = "eu-west-3"
}

variable "env" {
  type = string
  default = "test"
}

variable "namespace" {
  type = string
  default = "percenuage"
  description = "The namespace of VPC. ($NAMESPACE-$ENV-vpc)"
}
