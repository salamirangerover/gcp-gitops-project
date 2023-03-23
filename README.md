# GCP GitOps Project
Цель проекта - развернуть Production Ready платформу в Google Cloud Platform, основанную на следующем стеке технологий:
- Terraform
- k8s (Google Kubernetes Engine)
- ArgoCD

Использование:
```console
cd terraform/
terraform apply -var "project_id=<id-gcp-проекта>"

```

Terraform разворачивает GKE-кластер и ArgoCD, который разворачивает инфраструктурные-приложения (Kube Prometheus Stack, Grafana Loki, Ingress Nginx Controller, External DNS, Cert Manager) и другие веб-приложения(Wordpress и т.д.) по принципу "App of apps".

Мониторинг GKE-кластера и приложений осуществляется через Kube Prometheus Stack(Grafana, Alert Manager, Prometheus), логи собираются через Grafana Loki.

DNS-записи назначаются автоматически через External-DNS. 
IP-адрес берется у сервиса ingress-nginx-controller (External LoadBalancer), создается A-запись и добавляется в DNS-зону домена, которая расположена в Google Cloud DNS, тем самым обеспечивая доступность приложений в сети Интернет после развертывания GKE-кластера и ArgoCD.
Затем выпускается TLS-сертификат Let's Encrypt через cert-manager.

Требования:
- Аккаунт в Google Cloud Platform
- Необходим зарегистрированный домен, который необходимо направить на NS-сервера Google Cloud DNS.


