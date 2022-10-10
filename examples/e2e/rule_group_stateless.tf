variable "stateless_rule_group" {
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
