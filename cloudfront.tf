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
    domain_name = "vpce-0d7266209b48d91da-f66wb15m.elasticloadbalancing.ap-southeast-1.vpce.amazonaws.com"
    origin_id = test
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
    target_origin_id = test
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

# resource "aws_cloudfront_distribution" "example" {
#   domain_name = "example.com"
#   origin = "nddff"
#   origin_group = [
#     aws_cloudfront_origin_group.app1.id,
#     aws_cloudfront_origin_group.app2.id,
#   ]
#   default_cache_behavior {
#     allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = "user_dmz_lb_a"
#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#     viewer_protocol_policy = "allow-all"
#   }
#   default_origin_group_id = aws_cloudfront_origin_group.app1.id

#   custom_error_pages = {
#     404 = "error/404.html",
#     500 = "error/500.html",
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "blacklist"
#       countries = ["CN"]
#     }
#   }

#   viewer_certificate {
#     acm_certificate_arn = aws_acm_certificate.example.arn
#   }

#   web_acl_id = aws_wafv2_web_acl.example.id
# }

# resource "aws_cloudfront_origin_group" "app1" {
#   domain_name = "app1.example.com"

#   health_check {
#     interval = 10
#     timeout = 5
#     unhealthy_threshold = 3
#     path = "/"
#   }

#   members = [
#     aws_elb_target_group.app1.arn,
#   ]
# }

# resource "aws_cloudfront_origin_group" "app2" {
#   domain_name = "app2.example.com"

#   health_check {
#     interval = 10
#     timeout = 5
#     unhealthy_threshold = 3
#     path = "/"
#   }

#   members = [
#     aws_elb_target_group.app2.arn,
#   ]
# }

# resource "aws_elb_target_group" "app1" {
#   name = "app1-target-group"
#   port = 80

#   vpc_id = aws_vpc.example.id

#   health_check {
#     interval = 10
#     timeout = 5
#     unhealthy_threshold = 3
#     path = "/"
#   }

#   protocol = "HTTP"
# }

# resource "aws_elb_target_group" "app2" {
#   name = "app2-target-group"
#   port = 80

#   vpc_id = aws_vpc.example.id

#   health_check {
#     interval = 10
#     timeout = 5
#     unhealthy_threshold = 3
#     path = "/"
#   }

#   protocol = "HTTP"
# }