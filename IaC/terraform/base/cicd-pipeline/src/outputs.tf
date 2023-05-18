output "workspace" {
  description = "Nombre del workspace actual"
  value       = var.env
}

output "project_name" {
  description = "Nombre del proyecto"
  value       = var.project_name
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}