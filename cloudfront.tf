##############################################################################
################################# 1.create cloudfront ########################
##############################################################################

###################### a. cloudfront distribution ############################
resource "aws_cloudfront_distribution" "user_dmz_alb_cf" {
  enabled = true
  comment = "nadri-project-cf"
  aliases = [local.domain_name[0], local.domain_name[1]]
  web_acl_id = aws_wafv2_web_acl.cf_wacl.arn
  provider     = aws.virginia
  origin {
    domain_name = aws_lb.user_dmz_proxy_lb[0].dns_name
    origin_id = local.cf_origin_name[0]
    origin_shield {
      origin_shield_region = local.region
      enabled               = true
    }
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }    
  }
  origin {
    domain_name = aws_lb.user_dmz_proxy_lb[1].dns_name
    origin_id = local.cf_origin_name[1]
    origin_shield {
      origin_shield_region = local.region
      enabled               = true
    }
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
  }    
  }
    
  restrictions {
    geo_restriction {
        restriction_type = "blacklist"
        locations        = ["KP"]
  }
  }
  origin_group {
    origin_id = local.cf_origin_name[2]
    failover_criteria {
      status_codes = [403, 404, 500, 502, 500]
    }
    member {
      origin_id = local.cf_origin_name[0]
    }
    member {
      origin_id = local.cf_origin_name[1]
    }
  }
  
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.cf_origin_name[0]
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 1800
    max_ttl                = 21600    
    #response_headers_policy_id = aws_cloudfront_response_headers_policy.nadri.id
    forwarded_values {
    query_string = false
      cookies {
          forward = "none"
      }
    }
  }
  viewer_certificate {
    acm_certificate_arn         = aws_acm_certificate.cert.arn
    ssl_support_method          = "sni-only"
    minimum_protocol_version    = "TLSv1.2_2021"
  }
  # depends_on = [
  #   aws_wafv2_web_acl.cf_wacl
  # ]
}

###################### b. cloudfront heaers_policy ############################

# resource "aws_cloudfront_response_headers_policy" "nadri" {
#   name    = "nadri-policy"
#   comment = "nadri-project-com_policy"

#   cors_config {
#     access_control_allow_credentials = false

#     access_control_allow_headers {
#       items = ["*"]
#     }

#     access_control_allow_methods {
#       items = ["GET", "HEAD"]
#     }

#     access_control_allow_origins {
#       items = ["*.nadri-project.com"]
#     }

#     origin_override = true
#   }
# }

###################### c. cloudfront cache_policy ############################

# resource "aws_cloudfront_cache_policy" "user_dmz_cache_policy" {
#   name        = "user-dmz-policy"
#   comment     = "user-dmz-policy"
#   default_ttl = 50
#   max_ttl     = 100
#   min_ttl     = 1
#   parameters_in_cache_key_and_forwarded_to_origin {
#     cookies_config {
#       cookie_behavior = "whitelist"
#       cookies {
#         items = ["example"]
#       }
#     }
#     headers_config {
#       header_behavior = "whitelist"
#       headers {
#         items = ["example"]
#       }
#     }
#     query_strings_config {
#       query_string_behavior = "whitelist"
#       query_strings {
#         items = ["example"]
#       }
#     }
#   }
# }