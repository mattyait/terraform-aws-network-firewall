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

  #Domain Firewall Rule Group
  domain_stateful_rule_group = [
    {
      capacity    = 100
      name        = "DOMAINSFEXAMPLE1"
      description = "Stateful rule example1 with domain list option"
      domain_list = ["test.example.com", "test1.example.com"]
      actions     = "DENYLIST"
      protocols   = ["HTTP_HOST", "TLS_SNI"]
      rule_variables = [{
        key = "HOME_NET"                              #https://docs.aws.amazon.com/network-firewall/latest/developerguide/stateful-rule-groups-domain-names.html#stateful-rule-groups-domain-names-home-net
        ip_set = ["175.0.0.0/16","195.0.0.0/16"]      #Add this rule_variables if traffic is flowing from other VPC
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