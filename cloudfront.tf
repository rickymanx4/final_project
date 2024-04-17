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

resource "aws_cloudfront_distribution" "alb_beanstalk" {
    origin {
    domain_name = aws_lb.user_dmz_proxy_lb[0].dns_name
    origin_id = "test"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.3"]
    }    
    }

    enabled = true
    restrictions {
    geo_restriction {
    restriction_type = "none"
    }

    }
    default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "test"
    forwarded_values {
    query_string = false

    cookies {
        forward = "none"
    }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    }
    viewer_certificate {
    cloudfront_default_certificate = true
    }
    
    }

resource "aws_vpc_endpoint_service" "example" {
  acceptance_required        = false
  network_load_balancer_arns = aws_lb.user_dmz_proxy_lb[*].arn
}


# resource "aws_cloudfront_distribution" "user_dmz_distribution" {
#   depends_on = [
#     aws_lb.user_dmz_proxy_lb
#   ]
#   default_cache_behavior {
#     allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = "user_dmz_lb_a" "user_dmz_lb_a"
#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#     viewer_protocol_policy = "allow-all"
#   }

#   enabled = true

#   origin {
#     domain_name = aws_lb.user_dmz_proxy_lb[0].dns_name
#     origin_id   = local.cf_orgin_name[0]
#   }
#   origin {
#     domain_name = aws_lb.user_dmz_proxy_lb[1].dns_name
#     origin_id   = local.cf_orgin_name[1]
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "blacklist"
#       locations = ["CN"]
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }
#===============================================================

