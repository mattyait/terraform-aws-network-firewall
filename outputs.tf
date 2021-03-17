output "network_firewall_id_out" {
  description = "Created Network Firewall ID from network_firewall module"
  value       = aws_networkfirewall_firewall.main.id
}

output "network_firewall_arn_out" {
  description = "Created Network Firewall ARN from network_firewall module"
  value       = aws_networkfirewall_firewall.main.arn
}

output "network_firewall_endpoint_id" {
  description = "Created Network Firewall endpoint id"
  value       = flatten(aws_networkfirewall_firewall.main.firewall_status[*].sync_states[*].*.attachment[*])[*].endpoint_id
}