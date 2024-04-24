##############################################################################
#################################### 1.route53 record ########################
##############################################################################

######################### a. cloudfront attach ###############################

resource "aws_route53_record" "nadri" {
  zone_id        = local.host_zone
  name           = local.domain_name
  type           = "A"
  # set_identifier = "nadri-${local.az_ac[count.index]}"
  # records        = [aws_lb.user_dmz_proxy_lb.dns_name]
  # ttl            = 7200
  # weighted_routing_policy {
  #   weight = local.weight[count.index]
  # }
  alias {
    name                   = aws_cloudfront_distribution.user_dmz_alb_cf.domain_name
    zone_id                = aws_cloudfront_distribution.user_dmz_alb_cf.hosted_zone_id
    evaluate_target_health = true
  }  
}

resource "aws_route53_record" "www_nadri" {
  zone_id        = local.host_zone
  name           = "www.${local.domain_name}"
  type           = "A"
  alias {
    name                   = aws_cloudfront_distribution.user_dmz_alb_cf.domain_name
    zone_id                = aws_cloudfront_distribution.user_dmz_alb_cf.hosted_zone_id
    evaluate_target_health = true
  }  
}

##############################################################################
#################################### 2.ACM ###################################
##############################################################################

######################### a. ACM to route53 record ###########################
resource "aws_route53_record" "no_acm_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = local.host_zone
  depends_on = [ aws_acm_certificate.cert ]
}

# resource "aws_route53_record" "example" {
#   for_each = {
#     for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
#       name    = dvo.resource_record_name
#       record  = dvo.resource_record_value
#       type    = dvo.resource_record_type
#       zone_id = dvo.domain_name == "example.org" ? data.aws_route53_zone.example_org.zone_id : data.aws_route53_zone.example_com.zone_id
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = each.value.zone_id
# }

######################### b. ACM create ################################
resource "aws_acm_certificate" "cert" {
  domain_name                = local.domain_name
  subject_alternative_names  = ["www.${local.domain_name}"]
  validation_method          = "DNS"
  provider                   = aws.virginia
  tags = {
    Name = "nadri-crt"
  }
  lifecycle {
    create_before_destroy = true
  }
}

######################### c. ACM to route53 validation ###########################
# resource "aws_acm_certificate_validation" "cert_vali" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.no_acm_record : record.fqdn]
# }

