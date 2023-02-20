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

output "subnet_id" {
  description = "Created Network Firewall subnet id"
  value       = flatten(aws_networkfirewall_firewall.this.firewall_status[*].sync_states[*].attachment[*])[*].subnet_id
}

output "sync_states" {
  description = "Created Network Firewall states"
  value       = flatten(aws_networkfirewall_firewall.this.firewall_status[*].sync_states[*])
}

output "endpoint_id_az" {
  description = "Map value with Availability Zone and Firewall endpoint id"
  value       = { for val in flatten(aws_networkfirewall_firewall.this.firewall_status[*].sync_states[*]) : val.availability_zone => val.attachment[0].endpoint_id }
}
