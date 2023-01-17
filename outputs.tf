output "id" {
  description = "Created Network Firewall ID from network_firewall module"
  value       = aws_networkfirewall_firewall.this.id
}

output "arn" {
  description = "Created Network Firewall ARN from network_firewall module"
  value       = aws_networkfirewall_firewall.this.arn
}

output "endpoint_id" {
  description = "Created Network Firewall endpoint id"
  value       = flatten(aws_networkfirewall_firewall.this.firewall_status[*].sync_states[*].attachment[*])[*].endpoint_id
}
