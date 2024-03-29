resource "google_service_account" "main" {
  account_id   = "${local.cluster_name}-sa"
  display_name = "GKE Cluster ${local.cluster_name} Service Account"
}

resource "google_project_iam_binding" "project" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/dns.admin",
    "roles/storage.objectAdmin",
    "roles/iam.workloadIdentityUser"
  ])

  project = var.project_id
  role    = each.key
  members = [
    "serviceAccount:${google_service_account.main.email}"
  ]
}
