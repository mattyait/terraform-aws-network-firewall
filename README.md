#  AWS Network Firewall Module

AWS Network Firewall Module which creates

-  Stateful Firewall rule group with 5-tuple option
-  Stateful Firewall rule group domain option
-  Stateful firewall rule group with Suricta Compatible IPS rules option
- Statelless Furewall rule group
- Firewall Policy with attached above rule group
- Firewall Network

## Usage

    module "network_firewall" {
        source  = "mattyait/network-firewall/aws"
        version = "0.1.0"
        firewall_name = "example"
        vpc_id        = "vpc-27517c40"

        #Passing Individual Subnet ID to have required endpoint
        subnet_mapping = [
            { subnet_id : subnet-da6b7ebd },
            { subnet_id : subnet-a256d2fa }
        ]

        fivetuple_stateful_rule_group = [
            {
            capacity    = 100
            name        = "stateful"
            description = "Stateful rule example1 with 5 tuple option"
            rule_config = [{
                protocol              = "TCP"
                source_ipaddress      = "1.2.3.4/32"
                source_port           = 443
                destination_ipaddress = "124.1.1.5/32"
                destination_port      = 443
                direction             = "any"
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

## Inputs

| Name | Description |
|------|-------------|
|       |            |
## Outputs

| Name | Description |
|------|-------------|
|       |            |