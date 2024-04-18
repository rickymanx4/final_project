##############################################################################
#################################### 1.user_dmz_lb ###########################
##############################################################################

######################### a. target_groups ####################################

resource "aws_lb_target_group" "user_dmz_proxy_nginx_tg" {
  count            = 2
  name             = "${var.name[0]}-tg-nginx-${local.az_ac[count.index]}"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  target_type      = "instance"
  vpc_id           = aws_vpc.project_vpc[0].id
}
resource "aws_lb_target_group_attachment" "user_dmz_proxy_tg_att_80" {
  count            = 2
  target_group_arn = aws_lb_target_group.user_dmz_proxy_nginx_tg[count.index].arn
  target_id        = aws_instance.user_dmz_proxy[count.index].id
  port = 80
}



######################### b. load_balancer ####################################

resource "aws_lb" "user_dmz_proxy_lb" {
#  count              = 2
  name               = "${var.name[0]}-proxy-lb"
  load_balancer_type = "application"
  internal = false
  subnets = [aws_subnet.subnet_user_dmz_pub[2].id, aws_subnet.subnet_user_dmz_pub[3].id]
  security_groups = [aws_security_group.user_dmz_sg[0].id]
}

resource "aws_lb_listener" "user_proxy_lb_listener_80" {
  count             = 2
  load_balancer_arn = aws_lb.user_dmz_proxy_lb.arn
  port              = local.dmz_ports[2]
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_dmz_proxy_nginx_tg[count.index].arn
  }
}

resource "aws_lb_listener" "user_proxy_lb_listener_443" {
  count             = 2
  load_balancer_arn = aws_lb.user_dmz_proxy_lb.arn
  port              = local.dmz_ports[1]
  protocol          = "HTTPS"
  certificate_arn = local.proxy_acm
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_dmz_proxy_nginx_tg[count.index].arn
  }
}

# resource "aws_lb_listener_certificate" "user_dmz_proxy_crt" {
#   count           = 2
#   listener_arn    = aws_lb_listener.user_proxy_lb_listener_443[count.index].arn
#   certificate_arn = local.proxy_acm
# }


##############################################################################
#################################### 2.dev_dmz_lb ###########################
##############################################################################

######################### a. target_groups ####################################

resource "aws_lb_target_group" "dev_dmz_proxy_nginx_tg" {  
  count            = 2
  name             = "${var.name[1]}-tg-nginx-${local.az_ac[count.index]}"
  port             = 80
  protocol         = "TCP"
  target_type      = "instance"
  vpc_id = aws_vpc.project_vpc[1].id
}
resource "aws_lb_target_group_attachment" "dev_dmz_proxy_tg_att_80" {
  count            = 2
  target_group_arn = aws_lb_target_group.dev_dmz_proxy_nginx_tg[count.index].arn
  target_id        = aws_instance.dev_dmz_proxy[count.index].id
  port = 80
}


resource "aws_lb_target_group" "dev_dmz_nexus_tg" {
  count       = 2
  name        = "${var.name[1]}-nexus-tg-${local.az_ac[count.index]}"
  port        = 5555
  protocol    = "TCP"
  target_type = "ip"
  vpc_id = local.user_dev_vpc[1]
}

# resource "aws_lb_target_group_attachment" "dev_to_nexus_att" {
#     count            = 2 
#     target_group_arn = aws_lb_target_group.dev_dmz_nexus_tg[count.index].arn
#     target_id        = data.aws_network_interface.lb_ni[count.index].private_ip
#     port             = 22 
# }

######################### b. load_balancer ####################################

resource "aws_lb" "dev_dmz_proxy_lb" {
  count              = 2
  name               = "${var.name[1]}-proxy-lb-${local.az_ac[count.index]}"
  load_balancer_type = "network"
  internal = false
  subnets = [aws_subnet.subnet_dev_dmz_pub[count.index + 2].id]
  security_groups = [aws_security_group.dev_dmz_sg[0].id]
}

resource "aws_lb_listener" "dev_proxy_lb_listener_80" {
  count             = 2
  load_balancer_arn = aws_lb.dev_dmz_proxy_lb[count.index].arn
  port              = local.dmz_ports[2]
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_proxy_nginx_tg[count.index].arn
  }
}

resource "aws_lb_listener" "dev_proxy_lb_listener_443" {
  count             = 2
  load_balancer_arn = aws_lb.dev_dmz_proxy_lb[count.index].arn
  port              = local.dmz_ports[1]
  protocol          = "TCP"
  certificate_arn = local.proxy_acm
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_proxy_nginx_tg[count.index].arn
  }
}

# resource "aws_lb_listener_certificate" "dev_dmz_proxy_crt" {
#   count           = 2
#   listener_arn    = aws_lb_listener.dev_proxy_lb_listener_443[count.index].arn
#   certificate_arn = local.proxy_acm
# }

resource "aws_lb_listener" "dev_nexus_lb_listener" {
  count             = 2
  load_balancer_arn = aws_lb.dev_dmz_proxy_lb[count.index].arn
  port              = local.dmz_ports[3]
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_nexus_tg[count.index].arn
  }
}

##############################################################################
#################################### 3.shared_lb #############################
##############################################################################

######################### a. target_groups ####################################
resource "aws_lb_target_group" "nexus_tg" {
  count       = 2
  name        = "${var.name[2]}-nexus-ext-lb-tg-${local.az_ac[count.index]}"
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.project_vpc[2].id
}

resource "aws_lb_target_group_attachment" "nexus_tg_att" {
  count            = 2
  target_group_arn = aws_lb_target_group.nexus_tg[count.index].arn
  target_id        = aws_instance.shared_nexus[count.index].id
  port             = 22
}

resource "aws_lb_target_group" "shared_prome_tg" {
  count       = 2
  name        = "${var.name[2]}-${local.shared_ec2_name[0]}-tg-${local.az_ac[count.index]}"
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.project_vpc[2].id
}

resource "aws_lb_target_group" "shared_grafana_tg" {
  count       = 2
  name        = "${var.name[2]}-${local.shared_ec2_name[1]}-tg-${local.az_ac[count.index]}"
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.project_vpc[2].id
}

resource "aws_lb_target_group" "shared_elk_tg" {
  count       = 2
  name        = "${var.name[2]}-${local.shared_ec2_name[2]}-tg-${local.az_ac[count.index]}"
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.project_vpc[2].id
}
resource "aws_lb_target_group_attachment" "shared_prome_att" {
    count            = 2
    target_group_arn = aws_lb_target_group.shared_prome_tg[count.index].arn
    target_id        = aws_instance.shared_prometheus[count.index].id
    port             = 22
}

resource "aws_lb_target_group_attachment" "shared_grafana_att" {
    count            = 2
    target_group_arn = aws_lb_target_group.shared_grafana_tg[count.index].arn
    target_id        = aws_instance.shared_grafana[count.index].id
    port             = 22
}

resource "aws_lb_target_group_attachment" "shared_elk_att" {
    count            = 2
    target_group_arn = aws_lb_target_group.shared_elk_tg[count.index].arn
    target_id        = aws_instance.shared_elk[count.index].id
    port             = 22
}


######################### b. load_balancer ####################################

resource "aws_lb" "shared_ext_lb" {
  count               = 2
  name                = "${var.name[2]}-ext-lb-${local.az_ac[count.index]}"
  internal            = true
  load_balancer_type  = "network"
  subnets             = [aws_subnet.subnet_shared_pri_01[count.index].id]
  security_groups     = [ aws_security_group.shared_ext_lb_sg.id ]

  tags = {  
    Name = "${var.name[2]}-ext-lb-${local.az_ac[count.index]}"
    }
}
resource "aws_lb_listener" "nexus_listener" {
  count             = 2
  load_balancer_arn = aws_lb.shared_ext_lb[count.index].arn
  port              = "5555"
  protocol          = "TCP"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  # alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nexus_tg[count.index].arn
  }
}

resource "aws_lb" "shared_int" {
  count               = 2
  name                = "${var.name[2]}-int-lb-${local.az_ac[count.index]}"
  internal            = true
  load_balancer_type  = "network"
  subnets             = [aws_subnet.subnet_shared_pri_02[count.index].id]
  security_groups     = [ aws_security_group.shared_int_lb_sg.id ]

  tags = {
    Name = "${var.name[2]}-int-lb-${local.az_ac[count.index]}"
  }
}
resource "aws_lb_listener" "shared_int_linsten_prome" {
  count             = 2
  load_balancer_arn = aws_lb.shared_int[count.index].arn
  port              = local.shared_int_ports[0]
  protocol          = "TCP"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  # alpn_policy       = "HTTP2Preferred"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shared_prome_tg[count.index].arn
  }
}  

resource "aws_lb_listener" "shared_int_linsten_grafana" {
  count             = 2
  load_balancer_arn = aws_lb.shared_int[count.index].arn
  port              = local.shared_int_ports[1]
  protocol          = "TCP"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  # alpn_policy       = "HTTP2Preferred"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shared_grafana_tg[count.index].arn
  }
}  

resource "aws_lb_listener" "shared_int_linsten_elk" {
  count             = 2
  load_balancer_arn = aws_lb.shared_int[count.index].arn
  port              = local.shared_int_ports[2]
  protocol          = "TCP"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  # alpn_policy       = "HTTP2Preferred"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shared_elk_tg[count.index].arn
  }
}  

