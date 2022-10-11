# AWS Network Firewall Example with 5tuple rule option

It will create network firewall, firewall rule grup with priorities and rule config, Also it will create firewall policy with attached created rule group.

Data sources are used to discover existing VPC resources (VPC, subnet).

## Usage

To run this example you need to execute:

    terraform init
    terraform plan

## Module Reference Usage
```hcl
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

    #5 Tuple Firewall Rule Group
    fivetuple_stateful_rule_group = [
    {
        capacity    = 100
        name        = "5TUPLESFEXAMPLE1"
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
    }]


    # Stateless Rule Group
    stateless_rule_group = [
    {
        capacity    = 100
        name        = "SLEXAMPLE1"
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
        Environment = "test"
        Created_By  = "Terraform"
    }
}
```
