output "ext_lb_dns_name" {
  value = aws_alb.external_lb.dns_name
}
output "int_lb_dns_name" {
  value = aws_alb.internal_lb.dns_name
}
output "bastion_instance_id" {
  value = aws_instance.project_bastion.id
}
output "bastion_instance_ip" {
  value = aws_instance.project_bastion.public_ip
}
output "web_instance_id" {
  value = aws_instance.project_web.id
}
output "app_instance_id" {
  value = aws_instance.project_app.id
}
output "web_instance_ip" {
  value = aws_instance.project_web.private_ip
}
output "app_instance_ip" {
  value = aws_instance.project_app.private_ip
}
output "rds_endpoint" {
  value = aws_db_instance.blind_rds.endpoint
}
