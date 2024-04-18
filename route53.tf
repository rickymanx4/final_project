resource "aws_route53_record" "www-nadri" {
  count          = 2
  zone_id        = local.host_zone
  name           = "www"
  type           = "A"
  set_identifier = "nadri-${local.az_ac[count.index]}"
  #records        = [aws_lb.user_dmz_proxy_lb[count.index].dns_name]
  #ttl            = 7200
  weighted_routing_policy {
    weight = local.weight[count.index]
  }
  alias {
    name                   = aws_lb.user_dmz_proxy_lb[count.index].dns_name
    zone_id                = aws_lb.user_dmz_proxy_lb[count.index].zone.id
    evaluate_target_health = true
  }
  
}

