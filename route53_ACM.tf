##############################################################################
#################################### 1.route53 record ########################
##############################################################################

######################### a. cloudfront attach ###############################

resource "aws_route53_record" "nadri" {
  zone_id        = local.host_zone
# local.domain_name = ["nadri-project.com", "www.nadri-project.com"]  
  name           = local.domain_name[0]
  type           = "A"
  alias {
    name                   = aws_cloudfront_distribution.user_dmz_alb_cf.domain_name
    zone_id                = aws_cloudfront_distribution.user_dmz_alb_cf.hosted_zone_id
    evaluate_target_health = true
  }  
}

resource "aws_route53_record" "www_nadri" {
  zone_id        = local.host_zone  
  name           = local.domain_name[1]
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
  # route 53의 hosting zone은 고정으로 되어있음.
  zone_id         = local.host_zone
  depends_on = [ aws_acm_certificate.cert ]
}


######################### b. ACM create ################################
resource "aws_acm_certificate" "cert" {
  domain_name                = local.domain_name[0]
  subject_alternative_names  = [local.domain_name[1]]
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

