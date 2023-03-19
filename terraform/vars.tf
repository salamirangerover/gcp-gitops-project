variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

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
