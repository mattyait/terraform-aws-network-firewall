# Complete AWS Network Firewall Example

It will create network firewall, firewall rule grup with priorities and rule config, Also it will create firewall policy with attached created rule group.

Data sources are used to discover existing VPC resources (VPC, subnet).

## Usage

To run this example you need to execute:

    terraform init
    terraform plan

## Module Reference Usage

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

        #Suricate Firewall Rule Group
        suricata_stateful_rule_group = [
        {
            capacity    = 100
            name        = "SURICTASFEXAMPLE1"
            description = "Stateful rule example1 with suricta type including rule_variables"
            rules_file  = "./example.rules"
            # Rule Variables example with ip_sets and port_sets
            rule_variables = {
                ip_sets = [{
                        key    = "WEBSERVERS_HOSTS"
                        ip_set = ["10.0.0.0/16", "10.0.1.0/24", "192.168.0.0/16"]
                    },
                    {
                        key    = "EXTERNAL_HOST"
                        ip_set = ["0.0.0.0/0"]
                    }
                ]
                port_sets = [{
                    key       = "HTTP_PORTS"
                    port_sets = ["443", "80"]
                    }
                ]
            }

        },
        {
            capacity    = 150
            name        = "SURICTASFEXAMPLE2"
            description = "Stateful rule example2 with suricta type"
            rules_file  = "./example.rules"
        },
        ]

        #Domain Firewall Rule Group
        domain_stateful_rule_group = [
        {
            capacity    = 100
            name        = "DOMAINSFEXAMPLE1"
            description = "Stateful rule example1 with domain list option"
            domain_list = ["test.example.com", "test1.example.com"]
            actions     = "DENYLIST"
            protocols   = ["HTTP_HOST", "TLS_SNI"]
        },
        {
            capacity    = 150
            name        = "DOMAINSFEXAMPLE2"
            description = "Stateful rule example2 with domain list option"
            domain_list = ["sample.example.com"]
            actions     = "ALLOWLIST"
            protocols   = ["HTTP_HOST"]
        },
        ]

        #5 Tuple Firewall Rule Group
        fivetuple_stateful_rule_group = [
        {
            capacity    = 100
            name        = "5TUPLESFEXAMPLE1"
            description = "Stateful rule example1 with 5 tuple option multiple rules"
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
            },
            {
                description           = "Drop 80 Rule"
                protocol              = "IP"
                source_ipaddress      = "10.2.0.0/16"
                source_port           = "any"
                destination_ipaddress = "10.1.0.0/16"
                destination_port      = 80
                direction             = "forward"
                sid                   = 2
                actions = {
                    type = "drop"
                }
            }]
        },
        {
            capacity    = 100
            name        = "5TUPLESFEXAMPLE2"
            description = "Stateful rule example2 with 5 tuple option and rule_variables"
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
            # Rule Variables example with ip_sets and port_sets
            rule_variables = {
                ip_sets = [{
                        key    = "WEBSERVERS_HOSTS"
                        ip_set = ["10.0.0.0/16", "10.0.1.0/24", "192.168.0.0/16"]
                    },
                    {
                        key    = "EXTERNAL_HOST"
                        ip_set = ["0.0.0.0/0"]
                    }
                ]
                port_sets = [{
                    key       = "HTTP_PORTS"
                    port_sets = ["443", "80"]
                }]
            }
        }]

        # Stateless Rule Group
        stateless_rule_group = [
        {
            capacity    = 100
            name        = "SLEXAMPLE1"
            description = "Stateless example1 with TCP and ICMP rule"
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
            },
            {
                priority              = 2
                protocols_number      = [6] #TCP
                source_ipaddress      = "1.2.3.5/32"
                source_from_port      = 22
                source_to_port        = 22
                destination_ipaddress = "124.1.1.6/32"
                destination_from_port = 22
                destination_to_port   = 22
                tcp_flag = {
                    flags = ["SYN"]
                    masks = ["SYN", "ACK"]
                }
                actions = {
                    type = "drop"
                }
            },
            {
                priority              = 3
                protocols_number      = [1] #ICMP
                source_ipaddress      = "0.0.0.0/0"
                destination_ipaddress = "0.0.0.0/0"
                actions = {
                    type = "drop"
                }
            }]
        },
        {
            capacity    = 100
            name        = "SLEXAMPLE2"
            description = "Stateless rule example1"
            rule_config = [{
                priority              = 1
                protocols_number      = [6]
                source_ipaddress      = "1.2.3.7/32"
                source_from_port      = 8080
                source_to_port        = 8080
                destination_ipaddress = "124.1.1.8/32"
                destination_from_port = 8080
                destination_to_port   = 8080
                tcp_flag = {
                    flags = ["SYN"]
                    masks = ["SYN", "ACK"]
                }
                actions = {
                    type = "drop"
                }
            }]

        }
    ]


    tags = {
        Name        = "example"
        Environment = "Test"
        Created_By  = "Terraform"
    }
    }