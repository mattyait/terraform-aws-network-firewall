terraform {
  required_version = ">=1.0.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.31.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

variable "environment" {
  default = "test"
}

module "network_firewall" {
  source        = "../../"
  firewall_name = "example"
  vpc_id        = data.aws_vpc.default.id

  prefix = var.environment

  #Passing Individual Subnet ID to have required endpoint
  subnet_mapping = [
    tolist(data.aws_subnets.all.ids)[0],
    tolist(data.aws_subnets.all.ids)[1]
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
        port_sets = [
          {
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
        port_sets = [
          {
            key       = "HTTP_PORTS"
            port_sets = ["443", "80"]
          }
        ]
      }
    }
  ]

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
    Name        = "${var.environment}_example"
    Environment = var.environment
    Created_By  = "Terraform"
  }
}