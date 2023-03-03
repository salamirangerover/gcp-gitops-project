variable "project_id" {}

variable "cluster_name" {
  type        = string
  description = "cluster name"
  default     = "salamirangerover-cluster"
}

variable "region" {
  type        = string
  description = "cluster region"
  default     = "us-central1"
}

variable "location" {
  type        = string
  description = "cluster location"
  default     = "us-central1-a"
}
