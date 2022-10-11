output "id" {
  description = "Created Network Firewall ID from network_firewall module"
  value       = { for k, v in module.nfw : k => v.id }
}

output "arn" {
  description = "Created Network Firewall ARN from network_firewall module"
  value       = { for k, v in module.nfw : k => v.arn }
}

output "endpoint_id" {
  description = "Created Network Firewall endpoint id"
  value       = { for k, v in module.nfw : k => v.endpoint_id }
}
