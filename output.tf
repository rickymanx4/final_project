output "shared_ext_lb_ni_ips" {
  value = "${flatten([data.aws_network_interface.lb_ni.*.private_ips])}"
}

output "dev_dmz_nexus_dns_name" {
  value = aws_lb.dev_dmz_nexus_lb.dns_name
}

output "dev_dmz_nexus_eni_pub_ip" {
  value = [for eni in data.aws_network_interfaces.nexus_nlb_ni.ids : aws_network_interface.eni[eni].association ? aws_network_interface.eni[eni].association.public_ip : null]
}
