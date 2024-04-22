resource "aws_wafv2_rule_group" "cf_web_acl_rule_group" {
  capacity  = 100
  name      = local.wacl_name[0]
  scope     = local.wacl_scope[0]
  provider    = aws.virginia
#   default_action {
#     allow {}
#   }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = local.wacl_name[0]
    sampled_requests_enabled   = true
  }
  tags = {
    Name = local.wacl_name[0]
  }
  rule {
    name     = "allow_kr"
    priority = 10

    action {
      allow {}
    }

    statement {
      geo_match_statement {
        country_codes = ["KR"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow_kr"
      sampled_requests_enabled   = true
    }
  }  

  rule {
    name     = "block_iphone"
    priority = 20

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
}

resource "aws_wafv2_rule_group" "alb_web_acl_rule_group" {
  capacity  = 100
  name      = local.wacl_name[1]
  scope     = local.wacl_scope[1]

#   default_action {
#     allow {}
#   }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = local.wacl_name[1]
    sampled_requests_enabled   = true
  }
  tags = {
    Name = local.wacl_name[1]
  }
  rule {
    name     = "allow_kr"
    priority = 10

    action {
      allow {}
    }

    statement {
      geo_match_statement {
        country_codes = ["KR"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow_kr"
      sampled_requests_enabled   = true
    }
  }  

  rule {
    name     = "block_iphone"
    priority = 20

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
}

resource "aws_wafv2_web_acl" "cf_wacl" {
  name        = local.wacl_name[0]
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
    name     = "kr-iphone-rule-group"
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
      metric_name                = "kr-iphone-rule-group"
      sampled_requests_enabled   = true
    }
  }  
   
  tags = {
    Name = "kr-iphone-rule-group"
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.wacl_name[0]}-metric"
    sampled_requests_enabled   = true
  }
}

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
    metric_name                = "${local.wacl_name[0]}-metric"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "wacl_cf_asso" { 
  resource_arn = aws_cloudfront_distribution.user_dmz_alb_cf.arn
  web_acl_arn  = aws_wafv2_web_acl.cf_wacl.arn
  provider    = aws.virginia
}

resource "aws_wafv2_web_acl_association" "wacl_user_lb_asso" { 
  count        = 2
  resource_arn = local.user_dmz_alb[count.index]
  web_acl_arn  = aws_wafv2_web_acl.alb_wacl.arn
}

resource "aws_wafv2_web_acl_association" "wacl_dev_lb_asso" { 
  count        = 2
  resource_arn = local.dev_dmz_alb[count.index]
  web_acl_arn  = aws_wafv2_web_acl.alb_wacl.arn
}