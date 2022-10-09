resource "aws_networkfirewall_firewall" "this" {
  name                = "${var.prefix}-nfw-${var.firewall_name}"
  description         = coalesce(var.description, var.firewall_name)
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn
  vpc_id              = var.vpc_id

  firewall_policy_change_protection = var.firewall_policy_change_protection
  subnet_change_protection          = var.subnet_change_protection

  dynamic "subnet_mapping" {
    for_each = toset(var.subnet_mapping)

    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = var.tags
}

resource "aws_networkfirewall_rule_group" "suricata_stateful_group" {
  count = length(var.suricata_stateful_rule_group) > 0 ? length(var.suricata_stateful_rule_group) : 0
  type  = "STATEFUL"

  name        = var.suricata_stateful_rule_group[count.index]["name"]
  description = var.suricata_stateful_rule_group[count.index]["description"]
  capacity    = var.suricata_stateful_rule_group[count.index]["capacity"]

  rule_group {
    rules_source {
      rules_string = file(var.suricata_stateful_rule_group[count.index]["rules_file"])
    }

    dynamic "rule_variables" {
      for_each = [
        for b in lookup(var.suricata_stateful_rule_group[count.index], "rule_variables", {}) : b
        if length(b) > 1
      ]
      content {
        dynamic "ip_sets" {
          for_each = lookup(lookup(var.suricata_stateful_rule_group[count.index], "rule_variables", {}), "ip_sets", [])
          content {
            key = ip_sets.value["key"]
            ip_set {
              definition = ip_sets.value["ip_set"]
            }
          }
        }

        dynamic "port_sets" {
          for_each = lookup(lookup(var.suricata_stateful_rule_group[count.index], "rule_variables", {}), "port_sets", [])
          content {
            key = port_sets.value["key"]
            port_set {
              definition = port_sets.value["port_sets"]
            }
          }
        }
      }
    }


  }

  tags = merge(var.tags)
}

resource "aws_networkfirewall_rule_group" "domain_stateful_group" {
  count = length(var.domain_stateful_rule_group) > 0 ? length(var.domain_stateful_rule_group) : 0
  type  = "STATEFUL"

  name        = var.domain_stateful_rule_group[count.index]["name"]
  description = var.domain_stateful_rule_group[count.index]["description"]
  capacity    = var.domain_stateful_rule_group[count.index]["capacity"]

  rule_group {
    dynamic "rule_variables" {
      for_each = [
        for b in lookup(var.domain_stateful_rule_group[count.index], "rule_variables", {}) : b
        if length(b) > 1
      ]
      content {
        dynamic "ip_sets" {
          for_each = lookup(lookup(var.domain_stateful_rule_group[count.index], "rule_variables", {}), "ip_sets", [])
          content {
            key = ip_sets.value["key"]
            ip_set {
              definition = ip_sets.value["ip_set"]
            }
          }
        }

        dynamic "port_sets" {
          for_each = lookup(lookup(var.domain_stateful_rule_group[count.index], "rule_variables", {}), "port_sets", [])
          content {
            key = port_sets.value["key"]
            port_set {
              definition = port_sets.value["port_sets"]
            }
          }
        }
      }
    }

    rules_source {
      rules_source_list {
        generated_rules_type = var.domain_stateful_rule_group[count.index]["actions"]
        target_types         = var.domain_stateful_rule_group[count.index]["protocols"]
        targets              = var.domain_stateful_rule_group[count.index]["domain_list"]
      }
    }
  }

  tags = merge(var.tags)
}


resource "aws_networkfirewall_rule_group" "fivetuple_stateful_group" {
  count = length(var.fivetuple_stateful_rule_group) > 0 ? length(var.fivetuple_stateful_rule_group) : 0
  type  = "STATEFUL"

  name        = var.fivetuple_stateful_rule_group[count.index]["name"]
  description = var.fivetuple_stateful_rule_group[count.index]["description"]
  capacity    = var.fivetuple_stateful_rule_group[count.index]["capacity"]

  rule_group {
    rules_source {
      dynamic "stateful_rule" {
        for_each = var.fivetuple_stateful_rule_group[count.index].rule_config
        content {
          action = upper(stateful_rule.value.actions["type"])
          header {
            destination      = stateful_rule.value.destination_ipaddress
            destination_port = stateful_rule.value.destination_port
            direction        = upper(stateful_rule.value.direction)
            protocol         = upper(stateful_rule.value.protocol)
            source           = stateful_rule.value.source_ipaddress
            source_port      = stateful_rule.value.source_port
          }
          rule_option {
            keyword  = "sid"
            settings = ["${stateful_rule.value.sid}; msg:\"${try(stateful_rule.value.description, "")}\""]
          }
        }
      }
    }
  }

  tags = merge(var.tags)
}



resource "aws_networkfirewall_rule_group" "stateless_group" {
  count = length(var.stateless_rule_group) > 0 ? length(var.stateless_rule_group) : 0
  type  = "STATELESS"

  name        = var.stateless_rule_group[count.index]["name"]
  description = var.stateless_rule_group[count.index]["description"]
  capacity    = var.stateless_rule_group[count.index]["capacity"]

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        dynamic "stateless_rule" {
          for_each = var.stateless_rule_group[count.index].rule_config
          content {
            priority = stateless_rule.value.priority
            rule_definition {
              actions = ["aws:${stateless_rule.value.actions["type"]}"]
              match_attributes {
                source {
                  address_definition = stateless_rule.value.source_ipaddress
                }
                # If protocol is TCP : 6 or UDP :17 get source ports from variables and set in source_port block
                dynamic "source_port" {
                  for_each = contains(stateless_rule.value.protocols_number, 6) || contains(stateless_rule.value.protocols_number, 17) ? try(toset([{
                    from = stateless_rule.value.source_from_port,
                    to   = stateless_rule.value.source_to_port
                  }]), []) : []
                  content {
                    from_port = source_port.value.from
                    to_port   = source_port.value.to
                  }
                }
                destination {
                  address_definition = stateless_rule.value.destination_ipaddress
                }
                # If protocol is TCP : 6 or UDP :17 get destination ports from variables and set in destination_port block
                dynamic "destination_port" {
                  for_each = contains(stateless_rule.value.protocols_number, 6) || contains(stateless_rule.value.protocols_number, 17) ? try(toset([{
                    from = stateless_rule.value.destination_from_port,
                    to   = stateless_rule.value.destination_to_port
                  }]), []) : []
                  content {
                    from_port = destination_port.value.from
                    to_port   = destination_port.value.to
                  }
                }
                protocols = stateless_rule.value.protocols_number
                dynamic "tcp_flag" {
                  for_each = contains(stateless_rule.value.protocols_number, 6) || contains(stateless_rule.value.protocols_number, 17) ? try(toset([{
                    flag  = stateless_rule.value.tcp_flag["flags"],
                    masks = stateless_rule.value.tcp_flag["masks"]
                  }]), []) : []
                  content {
                    flags = tcp_flag.value.flag
                    masks = tcp_flag.value.masks
                  }
                }
              }
            }
          }
        }
      }
    }
  }


  tags = merge(var.tags)
}
resource "aws_networkfirewall_firewall_policy" "this" {
  name = "${var.prefix}-nfw-policy-${var.firewall_name}"

  firewall_policy {
    stateless_default_actions          = ["aws:${var.stateless_default_actions}"]
    stateless_fragment_default_actions = ["aws:${var.stateless_fragment_default_actions}"]

    #Stateless Rule Group Reference
    dynamic "stateless_rule_group_reference" {
      for_each = local.this_stateless_group_arn
      content {
        # Priority is sequentially as per index in stateless_rule_group list
        priority     = index(local.this_stateless_group_arn, stateless_rule_group_reference.value) + 1
        resource_arn = stateless_rule_group_reference.value
      }
    }

    #StateFul Rule Group Reference
    dynamic "stateful_rule_group_reference" {
      for_each = local.this_stateful_group_arn
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }
  }
  tags = merge(var.tags)
}

###################### Logging Config ######################

resource "aws_cloudwatch_log_group" "nfw" {
  for_each = try(var.logging_config, {})
  name     = "/aws/network-firewall/${each.key}"

  tags = merge(var.tags)

  retention_in_days = each.value.retention_in_days
}

resource "aws_networkfirewall_logging_configuration" "this" {
  count        = try(length(var.logging_config), 0) > 0 ? 1 : 0
  firewall_arn = aws_networkfirewall_firewall.this.arn
  logging_configuration {
    dynamic "log_destination_config" {
      for_each = var.logging_config
      content {
        log_destination = {
          logGroup = aws_cloudwatch_log_group.nfw[log_destination_config.key].name
        }
        log_destination_type = "CloudWatchLogs"
        log_type             = upper(log_destination_config.key)
      }

    }
  }
}
