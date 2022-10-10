# AWS Network Firewall Example with Domain rule option

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

        #Domain Firewall Rule Group
        domain_stateful_rule_group = [
        {
            capacity    = 100
            name        = "DOMAINSFEXAMPLE1"
            description = "Stateful rule example1 with domain list option"
            domain_list = ["test.example.com", "test1.example.com"]
            actions     = "DENYLIST"
            protocols   = ["HTTP_HOST", "TLS_SNI"]
            rule_variables = {
                ip_sets = [{
                    key    = "WEBSERVERS_HOSTS"
                    ip_set = ["10.0.0.0/16", "10.0.1.0/24", "192.168.0.0/16"]
                },
                {
                    key    = "EXTERNAL_HOST"
                    ip_set = ["0.0.0.0/0"]
                }]
                port_sets = [
                {
                    key       = "HTTP_PORTS"
                    port_sets = ["443", "80"]
                }]
            }
        }]

        tags = {
            Name        = "example"
            Environment = "test"
            Created_By  = "Terraform"
        }
    }
