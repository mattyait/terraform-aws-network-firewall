variable "stateless_rule_group" {
    default = [
            {
            capacity    = 100
            name        = "stateless"
            description = "Stateless rule example1"
            rule_config = [
                { # DROP all ICMP 
                    priority              = 1
                    protocols_number      = [1] #ICMP
                    source_ipaddress      = "0.0.0.0/0"
                    # source_from_port      = "any" #ICMP dont have port
                    # source_to_port        = "any" #ICMP dont have port
                    destination_ipaddress = "0.0.0.0/0"
                    # destination_from_port = "any" #ICMP dont have port
                    # destination_to_port   = "any" #ICMP dont have port
                    tcp_flag = {
                    flags = []
                    masks = []
                    }
                    actions = {
                    type = "drop"
                    }
                },
                # { # DROP TCP 443 FROM 10.1.0.0/16 
                #     priority              = 2
                #     protocols_number      = [6] #TCP
                #     source_ipaddress      = "10.1.0.0/16"
                #     source_from_port      = 443
                #     source_to_port        = 443
                #     destination_ipaddress = "0.0.0.0/0"
                #     destination_from_port = 443
                #     destination_to_port   = 443
                #     tcp_flag = {
                #     flags = []
                #     masks = []
                #     }
                #     actions = {
                #     type = "drop"
                #     }
                # }
            ]
        }]
}
