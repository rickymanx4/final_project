output "shared_ext_lb_ni_ips" {
  value = "${flatten([data.aws_network_interface.lb_ni.*.private_ips])}"
}

output "user_dmz_dns_name" {
  value = aws_lb.user_dmz_proxy_lb[*].dns_name
}

output "dev_dmz_dns_name" {
  value = aws_lb.dev_dmz_proxy_lb[*].dns_name
}

output "cf_wacl_arn" {
  value = aws_wafv2_web_acl.cf_wacl.arn
}