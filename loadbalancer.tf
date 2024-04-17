##############################################################################
#################################### 1.user_dmz_lb ###########################
##############################################################################

######################### a. target_groups ####################################

resource "aws_lb_target_group" "user_dmz_proxy_tg" {
  count       = 2
  name        = "user-dmz-target-group-${local.az_ac[count.index]}"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id = aws_vpc.project_vpc[0].id
}
resource "aws_lb_target_group_attachment" "user_dmz_proxy_tg_att_80" {
  count            = 2
  target_group_arn = aws_lb_target_group.user_dmz_proxy_tg[count.index].arn
  target_id        = aws_instance.user_dmz_proxy[count.index].id
  port = 80
}

resource "aws_lb_target_group_attachment" "user_dmz_proxy_tg_att_22" {
  count            = 2
  target_group_arn = aws_lb_target_group.user_dmz_proxy_tg[count.index].arn
  target_id        = aws_instance.user_dmz_proxy[count.index].id
  port = 22
}

######################### b. load_balancer ####################################

resource "aws_lb" "user_dmz_proxy_lb" {
  count              = 2
  name               = "user-dmz-proxy-lb-${local.az_ac[count.index]}"
  load_balancer_type = "network"
  internal = false
  subnets = [aws_subnet.subnet_user_dmz_pub[count.index +2 ].id]
  security_groups = [aws_security_group.dmz_elb_sg[0].id]
}

resource "aws_lb_listener" "user_proxy_lb_listener_80" {
  count             = 2
  load_balancer_arn = aws_lb.user_dmz_proxy_lb[count.index].arn
  port              = local.dmz_proxy_ports[0]
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_dmz_proxy_tg[count.index].arn
  }
}
# resource "aws_lb_listener" "user_nexus_lb_listener" {
#   count             = 2
#   load_balancer_arn = aws_lb.user_dmz_proxy_lb[count.index].arn
#   port              = local.dmz_lb_ports[0]
#   protocol          = "TCP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.dev_dmz_nexus_tg[count.index].arn
#   }
# }


##############################################################################
#################################### 2.dev_dmz_lb ###########################
##############################################################################

######################### a. target_groups ####################################

resource "aws_lb_target_group" "dev_dmz_proxy_tg" {  
  count       = 2
  name        = "dev-dmz-target-group-${local.az_ac[count.index]}"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id = aws_vpc.project_vpc[1].id
}
resource "aws_lb_target_group_attachment" "dev_dmz_proxy_tg_att_80" {
  count            = 2
  target_group_arn = aws_lb_target_group.dev_dmz_proxy_tg[count.index].arn
  target_id        = aws_instance.dev_dmz_proxy[count.index].id
  port = 80
}

resource "aws_lb_target_group_attachment" "dev_dmz_proxy_tg_att_22" {
  count            = 2
  target_group_arn = aws_lb_target_group.dev_dmz_proxy_tg[count.index].arn
  target_id        = aws_instance.dev_dmz_proxy[count.index].id
  port = 22
}

resource "aws_lb_target_group" "dev_dmz_nexus_tg" {
  count       = 2
  name        = "dev-nexus-target-group-${local.az_ac[count.index]}"
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
  name               = "dev-dmz-proxy-lb-${local.az_ac[count.index]}"
  load_balancer_type = "network"
  internal = false
  subnets = [aws_subnet.subnet_dev_dmz_pub[count.index + 2].id]
  security_groups = [aws_security_group.dmz_elb_sg[1].id]
}

resource "aws_lb_listener" "dev_proxy_lb_listener_80" {
  count             = 2
  load_balancer_arn = aws_lb.dev_dmz_proxy_lb[count.index].arn
  port              = local.dmz_proxy_ports[0]
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_proxy_tg[count.index].arn
  }
}

resource "aws_lb_listener" "dev_proxy_lb_listener_9009" {
  count             = 2
  load_balancer_arn = aws_lb.dev_dmz_proxy_lb[count.index].arn
  port              = local.dmz_proxy_ports[1]
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_proxy_tg[count.index].arn
  }
}

resource "aws_lb_listener" "dev_nexus_lb_listener" {
  count             = 2
  load_balancer_arn = aws_lb.dev_dmz_proxy_lb[count.index].arn
  port              = local.dmz_lb_ports[1]
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
  name        = "shared-nexus-ext-lb-tg-${local.az_ac[count.index]}"
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
  name        = "shared-${local.shared_ec2_name[0]}-tg-${local.az_ac[count.index]}"
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.project_vpc[2].id
}

resource "aws_lb_target_group" "shared_grafana_tg" {
  count       = 2
  name        = "shared-${local.shared_ec2_name[1]}-tg-${local.az_ac[count.index]}"
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.project_vpc[2].id
}

resource "aws_lb_target_group" "shared_elk_tg" {
  count       = 2
  name        = "shared-${local.shared_ec2_name[2]}-tg-${local.az_ac[count.index]}"
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
  name                = "shared-ext-lb-${local.az_ac[count.index]}"
  internal            = true
  load_balancer_type  = "network"
  subnets             = [aws_subnet.subnet_shared_pri_01[count.index].id]
  security_groups     = [ aws_security_group.shared_ext_lb_sg.id ]

  tags = {  
    Name = "shared-ext-lb-${local.az_ac[count.index]}"
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
  name                = "shared-int-lb-${local.az_ac[count.index]}"
  internal            = true
  load_balancer_type  = "network"
  subnets             = [aws_subnet.subnet_shared_pri_02[count.index].id]
  security_groups     = [ aws_security_group.shared_int_lb_sg.id ]

  tags = {
    Name = "shared-int-lb-${local.az_ac[count.index]}"
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

