variable "default_tags" {
  description = "(Required) Default tag for AWS resource"
  default = {
    env         = "e2e"
    project     = "network-firewall"
    github_repo = "github.com/tnx-journey-to-cloud/aws-network-firewall"
    component   = "nfw"
  }
}

variable "nfw" {
  default = {
    nfw_01 = {
      nfw_name = "nfw-demo"
      vpc_id = "vpc-0d392b34c74d51357"
      logging_config = {
         flow = {
            retention_in_days = 60
         },
         alert = {
            retention_in_days = 60
         }
      }
      subnet_mapping = [
        "subnet-03c6bb90f7edda745",
        "subnet-098ddb1096d05cb78",
        "subnet-0f22ff7e7db6f2ddd"
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
