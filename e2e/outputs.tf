output "id" {
  value = { for k, v in module.nfw: k => v.id }
}

output "arn" {
  value = { for k, v in module.nfw: k => v.arn }
}

output "endpoint_id" {
  description = "Created Network Firewall endpoint id"
  value       = { for k, v in module.nfw: k => v.endpoint_id }
}
