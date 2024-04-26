output "shared_ext_lb_ni_ips" {
  value = "${flatten([data.aws_network_interface.lb_ni.*.private_ips])}"
}

output "dev_dmz_nexus_dns_name" {
  value = aws_lb.dev_dmz_nexus_lb.dns_name
}

output "dev_dmz_nexus_eni_pub_ip" {
  value = [data.aws_network_interface.nexus_nlb_ni.association_public_ip]
}
