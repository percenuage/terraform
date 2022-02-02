variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable location {
  type = string
  default = "europe-west1-c"
}

variable "machine_type" {
  type = string
  default = "n1-standard-1"
}

variable "preemptible" {
  type = bool
  default = false
}

variable "disk_size_gb" {
  type = number
  default = 20
}

variable "disk_type" {
  type = string
  default = "pd-standard"
}

variable "image_type" {
  type = string
  default = "COS_CONTAINERD"
}

variable "autoscale_node" {
  type = bool
  default = true
}

variable "min_node_count" {
  type = number
  default = 1
}

variable "max_node_count" {
  type = number
  default = 10
}

variable "autoscaling_profile" {
  type = string
  default = "BALANCED"
}

variable "dns_cache_addon" {
  type = bool
  default = true
}

variable "private" {
  type = bool
  default = true
}

variable "master_ipv4_cidr_block" {
  type = string
  default = "172.16.0.0/28"
}

variable "network_name" {
  type = string
}

variable "subnetwork_name" {
  type = string
}

/* LOCALS */

locals {
  project = "${var.namespace}-${var.env}"
}
