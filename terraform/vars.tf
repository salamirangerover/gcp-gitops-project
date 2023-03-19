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

/*
REVIEW:

Предлагаю заменить variable на locals
ref: https://developer.hashicorp.com/terraform/tutorials/configuration-language/locals#locals
Почему?
В моем понимании есть семантическая разница, а именно:
locals - это как _private или __protected метод или атрибут, они должны использоваться только во внутренней логике проекта, скрытой от конечного потребителя
variables - это public, куда внешний пользователь может передавать аргумент

Это более справделиво для модулей, но как правило терраформ код передлывается в модули для DRY и упрощения.
Например - создание этого GKE кластера было бы клево сделать модулем ;)
*/
