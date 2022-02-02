variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable region {
  type = string
}

variable zone {
  type = string
}

variable "memory_size_gb" {
  type = number
  default = 1
}

variable "tier" {
  type = string
  default = "BASIC" # or STANDARD_HA
}

variable "redis_version" {
  type = string
  default = "REDIS_5_0"
}

variable "network" {
  type = string
}

/* LOCALS */

locals {}
