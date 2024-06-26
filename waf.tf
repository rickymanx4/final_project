##############################################################################
################################# 1. Rule_group ##############################
##############################################################################

####################### a. block iphone, allow kr for cf ########################

resource "aws_wafv2_rule_group" "cf_web_acl_rule_group" {
  capacity  = 100
  # cf-wacl
  name      = local.wacl_name[0]
  # CLOUDFRONT
  scope     = local.wacl_scope[0]
  provider  = aws.virginia
#   default_action {
#     allow {}
#   }
  visibility_config {
    cloudwatch_metrics_enabled = true
    # cf-wacl
    metric_name                = local.wacl_name[0]
    sampled_requests_enabled   = true
  }
  tags = {
    # cf-wacl
    Name = local.wacl_name[0]
  }

  rule {
    name     = "block_iphone"
    priority = 10

    action {
      block {}
    }
    statement {
      byte_match_statement {          
        field_to_match {
          single_header {
            name = "user-agent"
          }
        }
        search_string         = "iphone"
        positional_constraint = "CONTAINS"
        # rule_action_override {
        #   action_to_use{
        #     captcha {}
        #   }  
        # }        
        text_transformation {
          priority = 0
          type     = "LOWERCASE"
        }
      }
    }
    # captcha_config {
    #   immunity_time_property {
    #     immunity_time = 120
    #   }
    # }
  
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "block_iphone"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "allow_kr"
    priority = 20

    action {
      block {}
    }
    statement{
      not_statement{
        statement {
          geo_match_statement {
            country_codes = ["KR"]
          }
        }
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow_kr"
      sampled_requests_enabled   = true
    }
  
  }  
}

####################### b. block mac, allow kr for lb ########################

resource "aws_wafv2_rule_group" "alb_web_acl_rule_group" {
  capacity  = 100
  # lb-wacl
  name      = local.wacl_name[1]
  # REGIONAL
  scope     = local.wacl_scope[1]

#   default_action {
#     allow {}
#   }
  visibility_config {
    cloudwatch_metrics_enabled = true
    # lb-wacl
    metric_name                = local.wacl_name[1]
    sampled_requests_enabled   = true
  }
  tags = {
    # lb-wacl
    Name = local.wacl_name[1]
  }
  rule {
    name     = "block_iphone"
    priority = 10

    action {
      block {}
    }
    statement {
      byte_match_statement {          
        field_to_match {
          single_header {
            name = "user-agent"
          }
        }
        search_string         = "iphone"
        positional_constraint = "CONTAINS"
        text_transformation {
          priority = 0
          type     = "LOWERCASE"
        }
      }
    } 
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "block_iphone"
      sampled_requests_enabled   = true
    }
  }  
  rule {
    name     = "allow_kr"
    priority = 20

    action {
      block {}
    }
    # 국가 코드가 KR이 아니면 차단
    statement{
      not_statement{
        statement {
          geo_match_statement {
            country_codes = ["KR"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow_kr"
      sampled_requests_enabled   = true
    }
  }  
}

##############################################################################
########################## 1. Web Application Firewall #######################
##############################################################################

####################### a. waf for cf ########################
resource "aws_wafv2_web_acl" "cf_wacl" {
  # lb-wacl
  name        = local.wacl_name[0]
  # CLOUDFRONT 
  scope       = local.wacl_scope[0]
  description = "${local.wacl_scope[0]}_wacl"
  provider    = aws.virginia
  default_action {
    allow {}
  }
  dynamic "rule" {
    for_each = var.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority
      override_action {
         none {}
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value.aws_rg_name
          vendor_name = rule.value.aws_rg_vendor_name
        }       
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = true
      }
    }
  } 
  rule {
    name     = "kr-mac-rule-group"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.cf_web_acl_rule_group.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "kr-mac-rule-group"
      sampled_requests_enabled   = true
    }
  }  
   
  tags = {
    Name = "kr-mac-rule-group"
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.wacl_name[0]}-metric"
    sampled_requests_enabled   = true
  }
}

####################### b. waf for lb ########################

resource "aws_wafv2_web_acl" "alb_wacl" {
  name        = local.wacl_name[1]
  scope       = local.wacl_scope[1]
  description = "${local.wacl_scope[1]}_wacl"
  default_action {
    allow {}
  }
  dynamic "rule" {
    for_each = var.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority
      override_action {
         none {}
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value.aws_rg_name
          vendor_name = rule.value.aws_rg_vendor_name
        }       
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = true
      }
    }
  } 
  rule {
    name     = "kr-iphone-rule-group"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.alb_web_acl_rule_group.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "kr-iphone-rule-group"
      sampled_requests_enabled   = true
    }
  }  
   
  tags = {
    Name = "kr-iphone-rule-group"
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.wacl_name[1]}-metric"
    sampled_requests_enabled   = true
  }
}

####################### c. attach waf for lb ########################

resource "aws_wafv2_web_acl_association" "wacl_user_lb_asso" { 
  count        = 2
  # local.user_dmz_alb = tolist(data.aws_lb.user_alb_arn[*].arn) -> aws_lb.user_dmz_proxy_lb[count.index].arn 대체가능할듯?
  resource_arn = local.user_dmz_alb[count.index]
  web_acl_arn  = aws_wafv2_web_acl.alb_wacl.arn
}

resource "aws_wafv2_web_acl_association" "wacl_dev_lb_asso" { 
  count        = 2
  # local.dev_dmz_alb = tolist(data.aws_lb.dev_alb_arn[*].arn) -> aws_lb.dev_dmz_proxy_lb[count.index].arn 대체가능할듯?
  resource_arn = local.dev_dmz_alb[count.index]
  web_acl_arn  = aws_wafv2_web_acl.alb_wacl.arn
}



