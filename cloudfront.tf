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



resource "aws_cloudfront_distribution" "user_dmz_distribution" {
  depends_on = [
    aws_lb.user_dmz_proxy_lb
  ]
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = cf-origin
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
  }

  enabled = true

  origin {
    domain_name = aws_lb.user_dmz_proxy_lb[0].dns_name
    origin_id   = local.cf_orgin_name[0]
  }
  origin {
    domain_name = aws_lb.user_dmz_proxy_lb[1].dns_name
    origin_id   = local.cf_orgin_name[1]
  }

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations = ["CN"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}