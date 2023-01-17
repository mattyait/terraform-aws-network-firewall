locals {
  this_stateful_group_arn  = concat(aws_networkfirewall_rule_group.suricata_stateful_group[*].arn, aws_networkfirewall_rule_group.domain_stateful_group[*].arn, aws_networkfirewall_rule_group.fivetuple_stateful_group[*].arn, var.aws_managed_rule_group)
  this_stateless_group_arn = concat(aws_networkfirewall_rule_group.stateless_group[*].arn)
}
