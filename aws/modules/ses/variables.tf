variable "domains" {
  type = list(string)
  default = ["percenuage-dev.com"]
  description = "The domaine list."
}

variable "env" {
  type = string
  description = "The env of the VPC. [prod|staging|test|dev]"
}
