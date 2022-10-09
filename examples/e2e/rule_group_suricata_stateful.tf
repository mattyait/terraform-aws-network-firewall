variable "suricata_stateful_rule_group" {
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