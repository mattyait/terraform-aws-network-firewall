terraform {
  required_version = ">=1.0.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.50"
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
  prefix        = var.environment

  #Passing Individual Subnet ID to have required endpoint
  subnet_mapping = [
    tolist(data.aws_subnets.all.ids)[0],
    tolist(data.aws_subnets.all.ids)[1]
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
