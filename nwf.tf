


# resource "aws_networkfirewall_firewall_policy" "nwf_policy" {
#   name = "nwf_policy"

#   firewall_policy {
#     stateless_default_actions          = ["aws:forward_to_sfe"]
#     stateless_fragment_default_actions = ["aws:pass"]
#     stateless_rule_group_reference {
#       priority     = 1
#       resource_arn = aws_networkfirewall_rule_group.example.arn
#     }
#     #tls_inspection_configuration_arn = "arn:aws:network-firewall:REGION:ACCT:tls-configuration/example"
#   }

#   tags = {
#     Name = nwf_policy
#   }
# }









# resource "aws_networkfirewall_firewall" "network_firewall" { 
#   count                              = 2  
#   name                               = "${vars.name[0]-nwf}"
#   firewall_policy_arn                = aws_networkfirewall_firewall_policy.nwf_policy.arn
#   vpc_id                             = aws_vpc.project_vpc[0]
#   # 나중에 true로 변경
#   firewall_policy_change_protection  = false
#   subnet_change_protection           = false
#   subnet_mapping {
#     subnet_id = aws_subnet.user_dmz_pub_subnet[count.index + 2].id
#   }

#   tags = {
#     Name = "${vars.name[0]-nwf}" 
#   }

#   timeouts {
#     create = "20m"
#     update = "20m"
#     delete = "20m"
#   }
# }