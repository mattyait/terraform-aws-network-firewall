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

  #Suricate Firewall Rule Group
  suricata_stateful_rule_group = [
    {
      capacity    = 100
      name        = "SURICTASFEXAMPLE1"
      description = "Stateful rule example1 with suricta type"
      rules_file  = file("${path.root}/example.rules")
    },
    {
      capacity    = 150
      name        = "SURICTASFEXAMPLE2"
      description = "Stateful rule example2 with suricta type"
      rules_file  = file("${path.root}/example.rules")
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
        },

        {
          priority              = 2
          protocols_number      = [6]
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