variable "fivetuple_stateful_rule_group" {
  default = [
        {
        capacity    = 100
        name        = "five-tuple-stateful"
        description = "Stateful rule example1 with 5 tuple option"
        rule_config = [
          { # spoke A -> B : PASS ALL
            description = "# spoke A -> B : PASS ALL"
            protocol              = "IP"
            source_ipaddress      = "10.1.0.0/16"
            source_port           = "any"
            destination_ipaddress = "10.2.0.0/16"
            destination_port      = "any"
            direction             = "forward"
            actions = {
              type = "pass"
            }
            sid = 1
          },
          { # spoke B -> A : DROP IP:80
            description = "# spoke B -> A : DROP IP:80"
            protocol              = "IP"
            source_ipaddress      = "10.2.0.0/16"
            source_port           = "any"
            destination_ipaddress = "10.1.0.0/16"
            destination_port      = 80
            direction             = "forward"
            actions = {
              type = "drop"
            }
            sid = 2
          },
          { # internet -> alb -> spoke A : PASS ALL
            description = "# internet -> alb -> spoke A : PASS ALL"
            protocol              = "IP"
            source_ipaddress      = "10.11.0.0/16"
            source_port           = "any"
            destination_ipaddress = "10.1.0.0/16"
            destination_port      = "any"
            direction             = "forward"
            actions = {
              type = "pass"
            }
            sid = 3
          },
          # { # internet -> alb -> spoke B : DROP
          #   description = "# internet -> alb -> spoke B : DROP"
          #   protocol              = "IP"
          #   source_ipaddress      = "10.11.0.0/16"
          #   source_port           = "any"
          #   destination_ipaddress = "10.2.0.0/16"
          #   destination_port      = "any"
          #   direction             = "forward"
          #   actions = {
          #     type = "drop"
          #   }
          #   sid = 4
          # },
          { # spoke A -> internet download : DROP
            description = "# spoke A -> internet download : DROP"
            protocol              = "IP"
            source_ipaddress      = "10.1.0.0/16"
            source_port           = "any"
            destination_ipaddress = "any"
            destination_port      = "any"
            direction             = "forward"
            actions = {
              type = "drop"
            }
            sid = 5
          },
          { # spoke B -> internet download : ALERT
            description = "# spoke B -> internet download : ALERT"
            protocol              = "IP"
            source_ipaddress      = "10.2.0.0/16"
            source_port           = "any"
            destination_ipaddress = "any"
            destination_port      = "any"
            direction             = "forward"
            actions = {
              type = "alert"
            }
            sid = 6
          }
        ]
        }
      ]
}
