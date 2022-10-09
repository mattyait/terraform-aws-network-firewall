#  AWS Network Firewall Module

AWS Network Firewall Module which creates

-  Stateful Firewall rule group with 5-tuple option
-  Stateful Firewall rule group domain option
-  Stateful firewall rule group with Suricta Compatible IPS rules option
- Statelless Firewall rule group
- Firewall Policy with attached above rule group
- Firewall Network

## Usage

    module "network_firewall" {
        source  = "mattyait/network-firewall/aws"
        version = "0.1.2"
        firewall_name = "example"
        vpc_id        = "vpc-27517c40"
        prefix        = "test"

        #Passing Individual Subnet ID to have required endpoint
        subnet_mapping = [
            "subnet-da6b7ebd",
            "subnet-a256d2fa"
        ]

        fivetuple_stateful_rule_group = [
            {
            capacity    = 100
            name        = "stateful"
            description = "Stateful rule example1 with 5 tuple option"
            rule_config = [{
                description           = "Pass All Rule"
                protocol              = "TCP"
                source_ipaddress      = "1.2.3.4/32"
                source_port           = 443
                destination_ipaddress = "124.1.1.5/32"
                destination_port      = 443
                direction             = "any"
                sid                   = 1
                actions = {
                type = "pass"
                }
            }]
            },
        ]

        # Stateless Rule Group
        stateless_rule_group = [
            {
            capacity    = 100
            name        = "stateless"
            description = "Stateless rule example1"
            rule_config = [{
                priority              = 1
                protocols_number      = [6]
                source_ipaddress      = "1.2.3.4/32"
                source_from_port      = 443
                source_to_port        = 443
                destination_ipaddress = "124.1.1.5/32"
                destination_from_port = 443
                destination_to_port   = 443
                tcp_flag = {
                flags = ["SYN"]
                masks = ["SYN", "ACK"]
                }
                actions = {
                type = "pass"
                }
            }]
            }]

        tags = {
            Name        = "example"
            Environment = "Test"
            Created_By  = "Terraform"
        }
    }

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.31.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.nfw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_networkfirewall_firewall.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall) | resource |
| [aws_networkfirewall_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy) | resource |
| [aws_networkfirewall_logging_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_logging_configuration) | resource |
| [aws_networkfirewall_rule_group.domain_stateful_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.fivetuple_stateful_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.stateless_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.suricata_stateful_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `""` | no |
| <a name="input_domain_stateful_rule_group"></a> [domain\_stateful\_rule\_group](#input\_domain\_stateful\_rule\_group) | Config for domain type stateful rule group | `list` | `[]` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | firewall name | `string` | `"example"` | no |
| <a name="input_firewall_policy_change_protection"></a> [firewall\_policy\_change\_protection](#input\_firewall\_policy\_change\_protection) | (Option) A boolean flag indicating whether it is possible to change the associated firewall policy | `string` | `false` | no |
| <a name="input_fivetuple_stateful_rule_group"></a> [fivetuple\_stateful\_rule\_group](#input\_fivetuple\_stateful\_rule\_group) | Config for 5-tuple type stateful rule group | `list` | `[]` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | n/a | `map(any)` | `{}` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The descriptio for each environment, ie: bin-dev | `string` | n/a | yes |
| <a name="input_stateless_default_actions"></a> [stateless\_default\_actions](#input\_stateless\_default\_actions) | Default stateless Action | `string` | `"forward_to_sfe"` | no |
| <a name="input_stateless_fragment_default_actions"></a> [stateless\_fragment\_default\_actions](#input\_stateless\_fragment\_default\_actions) | Default Stateless action for fragmented packets | `string` | `"forward_to_sfe"` | no |
| <a name="input_stateless_rule_group"></a> [stateless\_rule\_group](#input\_stateless\_rule\_group) | Config for stateless rule group | `any` | n/a | yes |
| <a name="input_subnet_change_protection"></a> [subnet\_change\_protection](#input\_subnet\_change\_protection) | (Optional) A boolean flag indicating whether it is possible to change the associated subnet(s) | `string` | `false` | no |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | Subnet ids mapping to have individual firewall endpoint | `any` | n/a | yes |
| <a name="input_suricata_stateful_rule_group"></a> [suricata\_stateful\_rule\_group](#input\_suricata\_stateful\_rule\_group) | Config for Suricata type stateful rule group | `list` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags for the resources | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Created Network Firewall ARN from network\_firewall module |
| <a name="output_endpoint_id"></a> [endpoint\_id](#output\_endpoint\_id) | Created Network Firewall endpoint id |
| <a name="output_id"></a> [id](#output\_id) | Created Network Firewall ID from network\_firewall module |
<!-- END_TF_DOCS -->