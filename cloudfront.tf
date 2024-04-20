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

resource "aws_cloudfront_distribution" "user_dmz_alb_cf" {
  enabled = true
  comment = local.domain_name
  origin {
    domain_name = aws_lb.user_dmz_proxy_lb.dns_name
    origin_id = "user_dmz_alb_cf"
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
  # origin {
  #   domain_name = aws_lb.user_dmz_proxy_lb[1].dns_name
  #   origin_id = local.cf_origin_name[1]
  #     origin_shield {
  #       origin_shield_region = local.region
  #       enabled               = true
  #     }
  #     custom_origin_config {
  #       http_port              = 80
  #       https_port             = 443
  #       origin_protocol_policy = "match-viewer"
  #       origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1"]
  #   }    
  # }
    
    restrictions {
      geo_restriction {
          restriction_type = "whitelist"
          locations        = ["KR"]
    }
  }
  # origin_group {
  #   origin_id = local.cf_origin_name[2]
  #   failover_criteria {
  #     status_codes = [403, 404, 500, 502, 500]
  #   }
  #   member {
  #     origin_id = local.cf_origin_name[0]
  #   }
  #   member {
  #     origin_id = local.cf_origin_name[1]
  #   }
  # }
  
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "user_dmz_alb_cf"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 1800
    max_ttl                = 21600    
    forwarded_values {
    query_string = false
      cookies {
          forward = "none"
      }
    }
  }
  viewer_certificate {
    acm_certificate_arn         = local.acm_cert
    ssl_support_method          = "sni-only"
    minimum_protocol_version    = "TLSv1.2_2021"
  }
  
  }

# resource "aws_vpc_endpoint_service" "example" {
#   acceptance_required        = false
#   network_load_balancer_arns = aws_lb.user_dmz_proxy_lb[*].arn
# }


