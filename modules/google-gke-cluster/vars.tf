variable "project_id" {
  type        = string
}

variable "credentials_file" {
  type        = string
}

variable "region" {
  type        = string
}

variable "cluster_location" {
  type        = string
}

variable "cluster_name" {
  type        = string
}

variable "initial_node_count" {
  type        = number
}

variable "network" {
  type        = string
}

variable "subnetwork" {
  type        = string
}

variable "node_machine_type" {
  type      = string
  default   = "n1-standard-1"
}

variable "node_image_type" {
  type      = string
  default   = "COS"
}



