resource "aws_route53_record" "www-nadri" {
  count   = 2
  zone_id = local.host_zone.id
  name    = "www"
  type    = "CNAME"
  ttl     = 5
  set_identifier = "nadri-${local.az_ac[count.index]}"
  weighted_routing_policy {
    weight = local.weight[count.index]
  }
  alias {
    name                   = aws_lb.user_dmz_proxy_lb[count.index].dns_name
    zone_id                = local.host_zone
    evaluate_target_health = true
  }
  
}

