variable "prefix" {
  description = "The descriptio for each environment, ie: bin-dev"
  type        = string
}

variable "tags" {
  description = "The tags for the resources"
  type        = map(any)
  default     = {}
}

variable "description" {
  default = ""
}

variable "fivetuple_stateful_rule_group" {
  description = "Config for 5-tuple type stateful rule group"
  default     = []
}

variable "domain_stateful_rule_group" {
  description = "Config for domain type stateful rule group"
  default     = []
}

variable "suricata_stateful_rule_group" {
  description = "Config for Suricata type stateful rule group"
  default     = []
}

variable "stateless_rule_group" {
  description = "Config for stateless rule group"
}

variable "firewall_name" {
  description = "firewall name"
  type        = string
  default     = "example"
}

variable "subnet_mapping" {
  description = "Subnet ids mapping to have individual firewall endpoint"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "stateless_default_actions" {
  description = "Default stateless Action"
  type        = string
  default     = "forward_to_sfe"
}

variable "stateless_fragment_default_actions" {
  description = "Default Stateless action for fragmented packets"
  type        = string
  default     = "forward_to_sfe"
}

variable "firewall_policy_change_protection" {
  type        = string
  description = "(Option) A boolean flag indicating whether it is possible to change the associated firewall policy"
  default     = false
}

variable "subnet_change_protection" {
  type        = string
  description = "(Optional) A boolean flag indicating whether it is possible to change the associated subnet(s)"
  default     = false
}

variable "logging_config" {
  type    = map(any)
  default = {}
}
