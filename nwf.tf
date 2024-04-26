resource "aws_networkfirewall_rule_group" "nwf_rule_group" {
  capacity = 100
  name     = "nwf_rule_group"
  type     = "STATELESS"
  rule_group {
    rules_source {
      rules_string = <<-EOF
        pass tcp from any to any port 80
        pass tcp from any to any port 443
        pass tcp from 213.0.113.3 to any port 22
        drop tcp from any to any port 53
        drop tcp from any to any port 25
        drop tcp from any to any port 22
      EOF
    }
  }
}

resource "aws_networkfirewall_firewall_policy" "nwf_policy" {
  name = "nwf_policy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateless_rule_group_reference {
      priority     = 1  
      resource_arn = aws_networkfirewall_rule_group.nwf_rule_group.arn
    }


    # 알려지고 확인된 활성 봇넷과 기타 명령 및 제어(C2) 호스트의 여러 소스에서 자동 생성된 서명
    stateful_rule_group_reference {
      priority     = 1        
      resource_arn = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetStrictOrder"
    }

    # HTTP 봇넷을 탐지하는 서명
    stateful_rule_group_reference {
      priority     = 2          
      resource_arn = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetWebStrictOrder"
    }

    # 코인 채굴을 수행하는 악성 코드를 탐지하는 규칙이 포함된 서명
    stateful_rule_group_reference {
      priority     = 3          
      resource_arn = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareCoinminingStrictOrder"
    }            

    # 합법적이지만 손상되어 멜웨어를 호스팅을 할 수 있는 도메인 클래스에 대한 차단
    stateful_rule_group_reference {
      priority     = 4            
      resource_arn = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/AbusedLegitMalwareDomainsStrictOrder"
    }    

    # 봇넷을 호스팅하는 것으로 알려진 도메인에 대한 요청을 차단
    stateful_rule_group_reference {
      priority     = 5      
      resource_arn = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/BotNetCommandAndControlDomainsStrictOrder"
    }    
  }
}


resource "aws_networkfirewall_firewall" "user_network_firewall" { 
  name                               = "${var.name[0]}-nwf"
  firewall_policy_arn                = aws_networkfirewall_firewall_policy.nwf_policy.arn
  vpc_id                             = aws_vpc.project_vpc[0]
  # 나중에 true로 변경
  firewall_policy_change_protection  = false
  subnet_change_protection           = false
  subnet_mapping {
    subnet_id = [aws_subnet.subnet_user_dmz_pub[2].id, aws_subnet.subnet_user_dmz_pub[3].id]
  }
  tags = {
    Name = "${var.name[0]}-nwf" 
  }
#   timeouts {
#     create = "20m"
#     update = "20m"
#     delete = "20m"
#   }
}

resource "aws_networkfirewall_firewall" "dev_network_firewall" { 
  name                               = "${var.name[1]}-nwf"
  firewall_policy_arn                = aws_networkfirewall_firewall_policy.nwf_policy.arn
  vpc_id                             = aws_vpc.project_vpc[1]
  # 나중에 true로 변경
  firewall_policy_change_protection  = false
  subnet_change_protection           = false
  subnet_mapping {
    subnet_id = aws_subnet.subnet_dev_dmz_pub[2].id
  }
  subnet_mapping {
    subnet_id = aws_subnet.subnet_dev_dmz_pub[3].id    
  }
  tags = {
    Name = "${var.name[1]}-nwf" 
  }
}  
#   timeouts {
#     create = "20m"
#     update = "20m"
#     delete = "20m"
#   }