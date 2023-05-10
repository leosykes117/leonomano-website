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

variable "delete_bucket_artifact" {
  description = "Indica si debe eliminar al bucket para los artefactos del pipeline"
  type        = bool
}