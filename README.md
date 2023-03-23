# GCP GitOps Project
- Terraform
- GCP
- k8s (Google Kubernetes Engine)
- ArgoCD

Использование:
```console
cd terraform/
terraform apply -var "project_id=<id-gcp-проекта>"

```

Terraform разворачивает gke, argocd и init_app, которое разворачивает другие приложения (wordpress, kube-prometheus-stack, ingress-nginx-controller, external-dns, cert-manager и другие) по принципу app of apps.

DNS-записи назначаются автоматически через External-DNS,  IP-адрес берется у сервиса ingress-nginx-controller (external load-balancer), создается A-запись и добавляется в DNS-зону домена, которая расположена в Google Cloud DNS. 
Затем выпускается TLS-сертификат Let's Encrypt через cert-manager.

Все разворачивается само через terraform apply.
Единственное, что перед развертыванием нужно, чтобы был зарегистрирован домен и уже направлен на NS-сервера Google Cloud DNS.

