variable "default_tags" {
  description = "(Required) Default tag for AWS resource"
  default = {
    env       = "e2e"
    project   = "network-firewall"
    component = "nfw"
  }
}

variable "nfw" {
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
