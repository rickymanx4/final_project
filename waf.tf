resource "aws_wafv2_web_acl" "web_acl" {
  count = 2
  name  = local.wacl_name[count.index]
  scope = local.wacl_scope[count.index]

  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb_wacl"
    sampled_requests_enabled   = true
  }
  tags = {
    Name = "cf_wacl"
  }
  rule {
    name     = "allow_kr"
    priority = 1

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
    name     = local.waf_ruleset[0]
    priority = 10

    statement {
      managed_rule_group_statement {
        name        = local.waf_ruleset[0]
        vendor_name = "AWS"   
      }  
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.waf_ruleset[0]}metric"
      sampled_requests_enabled   = true
    }
  }    
  rule {
    name     = local.waf_ruleset[1]
    priority = 20

    statement {
      managed_rule_group_statement {
        name        = local.waf_ruleset[1]
        vendor_name = "AWS"
      }    
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.waf_ruleset[1]}metric"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = local.waf_ruleset[2]
    priority = 30

    statement {
      managed_rule_group_statement {
        name        = local.waf_ruleset[2]
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.waf_ruleset[2]}metric"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "block_iphone"
    priority = 40

    action {
      block {}
    }
    statement {
      not_statement {
        statement {
          regex_pattern_set_reference_statement {
            arn = aws_wafv2_regex_pattern_set.iphone.arn
            field_to_match {
              single_header {
                name = "user-agent"
              }
            }
            text_transformation {
              priority = 0
              type     = "lowercase"
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

resource "aws_wafv2_regex_pattern_set" "iphone" {
  name  = "iphone-pattern-set"
  scope = "REGIONAL"

  regular_expression {
    regex_string = "iPhone"
  }
}