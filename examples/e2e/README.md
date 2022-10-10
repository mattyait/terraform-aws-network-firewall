# Complete AWS Network Firewall Example

It will create network firewall, firewall rule grup with priorities and rule config, Also it will create firewall policy with attached created rule group.

Data sources are used to discover existing VPC resources (VPC, subnet).

## Usage

To run this example you need to execute:

    terraform init
    terraform plan

## Module Reference Usage

    module "nfw" {
        source  = "mattyait/network-firewall/aws"
        version = "x.y.z"
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