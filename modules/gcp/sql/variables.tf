variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable region {
  type = string
}

variable "database_version" {
  type = string
  default = "MYSQL_8_0"
}

variable disk_size {
  type = number
  default = 10
}

variable instance_tier {
  type = string
  default = "db-f1-micro"
}

variable users {
  type = list(string)
  default = []
}

variable databases {
  type = list(string)
}

variable "enable_backup" {
  type = bool
  default = false
}

variable "deletion_protection" {
  type = bool
  default = true
}

/* LOCALS */

locals {
  users = concat(["root"], var.users)
}
