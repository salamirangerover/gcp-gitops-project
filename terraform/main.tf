/*
REVIEW:

По лучшим практикам terraform, следует разделять файлы проекта eg.
terraform.tf - пин версий терраформа и указания провайдеров
main.tf - определение провайдеров
gke.tf - тут создается gke
kubernetes.tf - тут при помощи провайдера создаются ресурсы в k8s
data.tf - тут все датасорсы
*/

terraform {
  required_version = ">= 0.13"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.location
}

resource "google_service_account" "main" {
  account_id   = "${var.cluster_name}-sa"
  display_name = "GKE Cluster ${var.cluster_name} Service Account"
}

resource "google_project_iam_binding" "project" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/dns.admin"
  ])

  project = var.project_id
  role    = each.key
  members = [
    "serviceAccount:${google_service_account.main.email}"
  ]
}


resource "google_container_cluster" "main" {
  name               = var.cluster_name
  location           = var.location
  initial_node_count = 3
  node_config {
    service_account = google_service_account.main.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    disk_size_gb = 30
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [google_container_cluster.main]
  create_duration = "30s"
}

module "gke_auth" {
  depends_on           = [time_sleep.wait_30_seconds]
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id           = var.project_id
  cluster_name         = google_container_cluster.main.name
  location             = var.location
  use_private_endpoint = false
}

/*
REVIEW:

Предложу заменить многократные вызовы kubectl провайдера на helm provider,
Так же все опенсорсные решения перевести на helm с raw манифестов.

Про переменную additionalApplications, не нашел ее в официальном чарте, у нас сторонний
ref? https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/values.yaml
Но кажется, kubectl может применять только gcp-gitops-project/manifests/_init/init_app.yaml

*/

provider "kubectl" {
  host                   = module.gke_auth.host
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  token                  = module.gke_auth.token
  load_config_file       = false
}

### argocd 

data "kubectl_file_documents" "namespace" {
  content = file("../manifests/argocd/namespace.yaml")
}

data "kubectl_file_documents" "argocd" {
  content = file("../manifests/argocd/install.yaml")
}

data "kubectl_file_documents" "ingress" {
  content = file("../manifests/argocd/ingress.yaml")
}

resource "kubectl_manifest" "ingress" {
  count              = length(data.kubectl_file_documents.ingress.documents)
  yaml_body          = element(data.kubectl_file_documents.ingress.documents, count.index)
  override_namespace = "argocd"
}


resource "kubectl_manifest" "namespace" {
  count              = length(data.kubectl_file_documents.namespace.documents)
  yaml_body          = element(data.kubectl_file_documents.namespace.documents, count.index)
  override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd" {
  depends_on = [
    kubectl_manifest.namespace,
  ]
  count              = length(data.kubectl_file_documents.argocd.documents)
  yaml_body          = element(data.kubectl_file_documents.argocd.documents, count.index)
  override_namespace = "argocd"
}

### init_monitoring_app


data "kubectl_file_documents" "init_app" {
  content = file("../manifests/_init/init_app.yaml")
}


resource "kubectl_manifest" "init_app" {
  depends_on = [
    kubectl_manifest.argocd,
  ]
  count     = length(data.kubectl_file_documents.init_app.documents)
  yaml_body = element(data.kubectl_file_documents.init_app.documents, count.index)

}
