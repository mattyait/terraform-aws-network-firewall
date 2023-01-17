terraform {
  required_version = ">=1.0.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50.0"
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
  ]

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
    Name        = "${var.environment}_example"
    Environment = var.environment
    Created_By  = "Terraform"
  }
}
