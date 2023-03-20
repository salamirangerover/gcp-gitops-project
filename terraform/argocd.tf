# provider "kubectl" {
#   host                   = module.gke_auth.host
#   cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
#   token                  = module.gke_auth.token
#   load_config_file       = false
# }

### argocd 

# data "kubectl_file_documents" "namespace" {
#   content = file("../manifests/argocd/namespace.yaml")
# }

# data "kubectl_file_documents" "argocd" {
#   content = file("../manifests/argocd/install.yaml")
# }

# data "kubectl_file_documents" "ingress" {
#   content = file("../manifests/argocd/ingress.yaml")
# }

# resource "kubectl_manifest" "ingress" {
#   count              = length(data.kubectl_file_documents.ingress.documents)
#   yaml_body          = element(data.kubectl_file_documents.ingress.documents, count.index)
#   override_namespace = "argocd"
# }


# resource "kubectl_manifest" "namespace" {
#   count              = length(data.kubectl_file_documents.namespace.documents)
#   yaml_body          = element(data.kubectl_file_documents.namespace.documents, count.index)
#   override_namespace = "argocd"
# }

# resource "kubectl_manifest" "argocd" {
#   depends_on = [
#     kubectl_manifest.namespace,
#   ]
#   count              = length(data.kubectl_file_documents.argocd.documents)
#   yaml_body          = element(data.kubectl_file_documents.argocd.documents, count.index)
#   override_namespace = "argocd"
# }

### init_monitoring_app
resource "helm_release" "argocd" {

  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true


  # values = [
  #   file("manifests/init_app.yaml")
  # ]

}


data "kubectl_file_documents" "init_app" {
  content = file("../manifests/_init/init_app.yaml")
}


resource "kubectl_manifest" "init_app" {
  depends_on = [
    helm_release.argocd,
  ]
  count     = length(data.kubectl_file_documents.init_app.documents)
  yaml_body = element(data.kubectl_file_documents.init_app.documents, count.index)

}
