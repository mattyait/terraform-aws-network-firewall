variable "default_tags" {
  description = "(Required) Default tag for AWS resource"
  default = {
    env       = "e2e"
    project   = "network-firewall"
    component = "nfw"
  }
  type = map(any)
}

variable "nfw" {
  description = "network firewall configuration"
  type        = any
  default = {
    nfw_01 = {
      nfw_name = "nfw-demo"
      vpc_id   = "vpc-827eabe6"
      logging_config = {
        flow = {
          retention_in_days = 60
        },
        alert = {
          retention_in_days = 60
        }
      }
      subnet_mapping = [
        "subnet-bc61f1d8",
        "subnet-a611a9d0",
        "subnet-f2a100ab"
      ]
      # Five Tuple Firewall Rule Group
      fivetuple_stateful_rule_group = []

      # Stateless Rule Group
      stateless_rule_group = []

      #Suricate Firewall Rule Group
      suricata_stateful_rule_group = []

      #Domain Firewall Rule Group
      domain_stateful_rule_group = []
    }
  }
}

variable "domain_stateful_rule_group" {
  description = "Config for domain type stateful rule group"
  default     = []
  type        = any
}

variable "fivetuple_stateful_rule_group" {
  description = "Config for 5-tuple type stateful rule group"
  type        = any
  default = [
    {
      capacity    = 100
      name        = "five-tuple-stateful"
      description = "Stateful rule example1 with 5 tuple option"
      rule_config = [
        { # spoke A -> B : PASS ALL
          description           = "# spoke A -> B : PASS ALL"
          protocol              = "IP"
          source_ipaddress      = "10.1.0.0/16"
          source_port           = "any"
          destination_ipaddress = "10.2.0.0/16"
          destination_port      = "any"
          direction             = "forward"
          sid                   = 1
          actions = {
            type = "pass"
          }
        },
        { # spoke B -> A : DROP IP:80
          description           = "# spoke B -> A : DROP IP:80"
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
        },
        { # internet -> alb -> spoke A : PASS ALL
          description           = "# internet -> alb -> spoke A : PASS ALL"
          protocol              = "IP"
          source_ipaddress      = "10.11.0.0/16"
          source_port           = "any"
          destination_ipaddress = "10.1.0.0/16"
          destination_port      = "any"
          direction             = "forward"
          sid                   = 3
          actions = {
            type = "pass"
          }
        },
        { # spoke A -> internet download : DROP
          description           = "# spoke A -> internet download : DROP"
          protocol              = "IP"
          source_ipaddress      = "10.1.0.0/16"
          source_port           = "any"
          destination_ipaddress = "any"
          destination_port      = "any"
          direction             = "forward"
          sid                   = 4
          actions = {
            type = "drop"
          }
        },
        { # spoke B -> internet download : ALERT
          description           = "# spoke B -> internet download : ALERT"
          protocol              = "IP"
          source_ipaddress      = "10.2.0.0/16"
          source_port           = "any"
          destination_ipaddress = "any"
          destination_port      = "any"
          direction             = "forward"
          sid                   = 5
          actions = {
            type = "alert"
          }
        }
      ]
    }
  ]
}

variable "stateless_rule_group" {
  description = "Config for stateless rule group"
  type        = any
  default = [
    {
      capacity    = 100
      name        = "stateless"
      description = "Stateless rule example1"
      rule_config = [
        {
          # DROP all ICMP
          priority              = 1
          protocols_number      = [1] #ICMP
          source_ipaddress      = "0.0.0.0/0"
          destination_ipaddress = "0.0.0.0/0"
          actions = {
            type = "drop"
          }
        },
      ]
  }]
}

variable "suricata_stateful_rule_group" {
  description = "Config for Suricata type stateful rule group"
  type        = any
  default = [
    {
      capacity    = 100
      name        = "Suricata-example-rules"
      description = "Stateful rule example with suricta type"
      rules_file  = "./example.rules"
      rule_variables = {
        ip_sets = [
          {
            key    = "HOME_NET"
            ip_set = ["10.0.0.0/8"]
          },
          {
            key    = "EXTERNAL_NET"
            ip_set = ["0.0.0.0/0"]
          }
        ]
      }
    },
  ]
}
