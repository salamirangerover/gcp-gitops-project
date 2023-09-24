variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

locals {
  cluster_name = "salamirangerover-cluster"
  region       = "us-central1"
  location     = "us-central1-a"
}