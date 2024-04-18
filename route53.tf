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
  validation_record_fqdns = [for record in aws_route53_record.cert_vali : record.fqdn]
}