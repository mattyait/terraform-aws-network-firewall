provider "aws" {
  region = "ap-southeast-2"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

variable "environment" {
  default = "test"
}

module "network_firewall" {
  source        = "../../"
  firewall_name = "${var.environment}-example"
  vpc_id        = data.aws_vpc.default.id

  #Passing Individual Subnet ID to have required endpoint
  subnet_mapping = [
    { subnet_id : tolist(data.aws_subnet_ids.all.ids)[0] },
    { subnet_id : tolist(data.aws_subnet_ids.all.ids)[1] }
  ]

  #5 Tuple Firewall Rule Group
  fivetuple_stateful_rule_group = [
    {
      capacity    = 100
      name        = "5TUPLESFEXAMPLE1"
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