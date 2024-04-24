output "shared_ext_lb_ni_ips" {
  value = "${flatten([data.aws_network_interface.lb_ni.*.private_ips])}"
}

output "dev_dmz_nexus_dns_name" {
  value = aws_lb.dev_dmz_nexus_lb.dns_name
}

