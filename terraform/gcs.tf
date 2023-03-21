resource "google_storage_bucket" "loki_bucket" {
  name          = "salamirangerover_loki_bucket"
  location      = ""
  force_destroy = true
  project       = var.project_id

  #   public_access_prevention = "enforced"
}
