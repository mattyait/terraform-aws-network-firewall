output "this_aws_network_firewall_id" {
  description = "The ID of network firewall"
  value       = module.network_firewall.id
}

output "this_aws_network_firewall_arn" {
  description = "The ARN of network firewall"
  value       = module.network_firewall.arn
}

output "this_aws_network_firewall_endpoint" {
  description = "The endppints of network firewall"
  value       = module.network_firewall.endpoint_id
}