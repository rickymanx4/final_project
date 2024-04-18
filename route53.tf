resource "aws_route53_record" "www-nadri" {
  zone_id        = local.host_zone
  name           = "www"
  type           = "A"
  # set_identifier = "nadri-${local.az_ac[count.index]}"
  # records        = [aws_lb.user_dmz_proxy_lb.dns_name]
  # ttl            = 7200
  # weighted_routing_policy {
  #   weight = local.weight[count.index]
  # }
  alias {
    name                   = aws_lb.user_dmz_proxy_lb.dns_name
    zone_id                = aws_lb.user_dmz_proxy_lb.zone_id
    evaluate_target_health = true
  }  
}

resource "aws_route53_record" "acm_record" {
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
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "nadri-project.com"
  validation_method = "DNS"

  tags = {
    Environment = "nadri-cst"
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_acm_certificate_validation" "cert_vali" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_record : record.fqdn]
}