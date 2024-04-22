resource "aws_wafv2_rule_group" "web_acl_rule_group" {
  count     = 2
  capacity  = 100
  name      = local.wacl_name[count.index]
  scope     = local.wacl_scope[count.index]

#   default_action {
#     allow {}
#   }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = local.wacl_name[count.index]
    sampled_requests_enabled   = true
  }
  tags = {
    Name = local.wacl_name[count.index]
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

resource "aws_wafv2_web_acl" "wacl" {
  count       = 2
  name        = local.wacl_name[count.index]
  scope       = local.wacl_scope[count.index]
  description = "${local.wacl_scope[count.index]}_wacl"
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
        arn = aws_wafv2_rule_group.web_acl_rule_group.arn
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
    metric_name                = "${local.wacl_name[count.index]}-metric"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "wacl_cf_asso" { 
  resource_arn = aws_cloudfront_distribution.user_dmz_alb_cf.arn
  web_acl_arn  = aws_wafv2_web_acl.wacl[0].arn
}

resource "aws_wafv2_web_acl_association" "wacl_lb_asso" { 
  count        = 4
  resource_arn = data.aws_lbs.alb_arn[count.index].arn
  web_acl_arn  = aws_wafv2_web_acl.wacl[1].arn
}