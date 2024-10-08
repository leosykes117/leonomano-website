variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "aws_profile" {
  description = "Nombre del perfil que se ocupara para la creación de los recursos"
  type        = string
}

variable "shared_credentials_file" {
  description = "Nombre del perfil que se ocupara para la creación de los recursos"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "Region de AWS para todos los recursos"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Nombre del ambiente que se está trabajando"
  type        = string
}

variable "delete_bucket_hosting" {
  description = "Indica si debe eliminar al bucket del hosting cuando se aplique un destroy"
  type        = bool
}

variable "domain_name" {
  description = "Nombre del dominio para el sitio web"
  type        = string
}

variable "cloudflare_api_token" {
  description = "The API Token for Cloudflare operations"
  type        = string
  sensitive   = true
}
