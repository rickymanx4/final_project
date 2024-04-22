resource "aws_wafv2_rule_group" "web_acl_rule_group" {
#  count     = 2
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
      not_statement {
        statement {
          byte_match_statement {          
            field_to_match {
              single_header {
                name = "user-agent"
              }
            }
            search_string         = "iphone"
            positional_constraint = "STARTS_WITH"
            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
          }
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

# resource "aws_wafv2_regex_pattern_set" "iphone" {
#   name  = "iphone-pattern-set"
#   scope = "REGIONAL"

#   regular_expression {
#     regex_string = "iphone"
#   }
# }




resource "aws_wafv2_web_acl" "wacl" {
  name  = "wacl"
  scope = "REGIONAL"

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
        cloudwatch_metrics_enabled = false
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = false
      }
    }
  } 
  rule {
    name     = "example-rule-group"
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
      cloudwatch_metrics_enabled = false
      metric_name                = "exampleRuleGroup"
      sampled_requests_enabled   = false
    }
  }  
   
  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}