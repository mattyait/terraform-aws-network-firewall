# AWS Network Firewall Example with Suricta rule option

It will create network firewall, firewall rule grup with priorities and rule config, Also it will create firewall policy with attached created rule group.

Data sources are used to discover existing VPC resources (VPC, subnet).

## Usage

To run this example you need to execute:

    terraform init
    terraform plan

## Module Reference Usage

    module "network_firewall" {
        source  = "mattyait/network-firewall/aws"
        version = "x.y.z"
        firewall_name = "example"
        vpc_id        = "vpc-27517c40"
        prefix        = "test"

        #Passing Individual Subnet ID to have required endpoint
        subnet_mapping = [
                "subnet-da6b7ebd",
                "subnet-a256d2fa"
        ]

        #Suricate Firewall Rule Group
        suricata_stateful_rule_group = [
        {
            capacity    = 100
            name        = "SURICTASFEXAMPLE1"
            description = "Stateful rule example1 with suricta type"
            rules_file  = "./example.rules"
        }]

        tags = {
            Name        = "example"
            Environment = "test"
            Created_By  = "Terraform"
        }
    }
