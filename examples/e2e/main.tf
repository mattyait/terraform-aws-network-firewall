module "nfw" {
  source = "../../"

  for_each = var.nfw

  firewall_name  = each.value.nfw_name
  vpc_id         = each.value.vpc_id
  subnet_mapping = each.value.subnet_mapping
  logging_config = try(each.value.logging_config, {})

  prefix = local.app_env_prefix
  # Five Tuple Firewall Rule Group
  fivetuple_stateful_rule_group = try(concat(each.value.fivetuple_stateful_rule_group, var.fivetuple_stateful_rule_group), [])

  # Stateless Rule Group
  stateless_rule_group = try(concat(each.value.stateless_rule_group, var.stateless_rule_group), [])

  #Suricate Firewall Rule Group
  suricata_stateful_rule_group = try(concat(each.value.suricata_stateful_rule_group, var.suricata_stateful_rule_group), [])

  #Domain Firewall Rule Group
  domain_stateful_rule_group = try(concat(each.value.domain_stateful_rule_group, var.domain_stateful_rule_group), [])
  tags = {
    "end_to_end" = "true"
  }
}
locals {
  app_env_prefix = "${lookup(var.default_tags, "component", "-")}-${lookup(var.default_tags, "env", "-")}"
}
