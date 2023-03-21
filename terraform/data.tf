variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

locals {
  cluster_name = "salamirangerover-cluster"
  region       = "us-central1"
  location     = "us-central1-a"
}

# variable "cluster_name" {
#   type        = string
#   description = "cluster name"
#   default     = "salamirangerover-cluster"
# }

# variable "region" {
#   type        = string
#   description = "cluster region"
#   default     = "us-central1"
# }

# variable "location" {
#   type        = string
#   description = "cluster location"
#   default     = "us-central1-a"
# }
