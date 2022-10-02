variable "domain_stateful_rule_group" {
  default = []
  # default = [
  #   {
  #     capacity    = 100
  #     name        = "DENY-Domain-List"
  #     description = "Stateful rule example1 with domain list option"
  #     domain_list = ["test.example.com", "google.com", "vnexpress.net"]
  #     actions     = "DENYLIST"
  #     protocols   = ["HTTP_HOST", "TLS_SNI"]
  #     rule_variables = [{
  #       key = "HOME_NET"                              #https://docs.aws.amazon.com/network-firewall/latest/developerguide/stateful-rule-groups-domain-names.html#stateful-rule-groups-domain-names-home-net
  #       ip_set = ["10.0.0.0/8"]      #Add this rule_variables if traffic is flowing from other VPC
  #     }]
  #   },
  # ]
  #   {
  #     capacity    = 150
  #     name        = "ALLOW-Domain-list"
  #     description = "Stateful rule example2 with domain list option"
  #     domain_list = ["sample.example.com"]
  #     actions     = "ALLOWLIST"
  #     protocols   = ["HTTP_HOST"]
  #   }
  # ]
}

