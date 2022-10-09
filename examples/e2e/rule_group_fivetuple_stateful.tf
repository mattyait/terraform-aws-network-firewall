variable "fivetuple_stateful_rule_group" {
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
