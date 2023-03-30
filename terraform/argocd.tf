resource "helm_release" "argocd" {

  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "5.24.4"
  # version          = "5.17.0"

}

### infrastructure_apps
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

### user_apps
data "kubectl_file_documents" "user_app" {
  content = file("../manifests/_init/user_app.yaml")
}


resource "kubectl_manifest" "user_app" {
  depends_on = [
    helm_release.argocd, kubectl_manifest.init_app,
  ]
  count     = length(data.kubectl_file_documents.user_app.documents)
  yaml_body = element(data.kubectl_file_documents.user_app.documents, count.index)

}
