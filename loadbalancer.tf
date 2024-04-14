###
# 1. External-Loadb-Balancer
###

resource "aws_lb_target_group" "user_dmz_proxy_tg" {
  count       = 2
  name        = "user-dmz-target-group-${local.az_ac[count.index]}"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id = aws_vpc.project_vpc[0].id
}
resource "aws_lb_target_group_attachment" "user_dmz_proxy_tg_att" {
  count            = 2
  target_group_arn = aws_lb_target_group.user_dmz_proxy_tg[count.index].arn
  target_id        = aws_instance.user_dmz_proxy[count.index].id
  port = 80
}

resource "aws_lb_target_group" "user_dmz_nexus_tg" {
  count       = 2
  name        = "user-nexus-target-group-${local.az_ac[count.index]}"
  port        = 5000
  protocol    = "TCP"
  target_type = "ip"
  vpc_id = local.user_dev_vpc[0]
}

# resource "aws_lb_target_group_attachment" "user_dmz_to_nexus_att" {
#   count            = 2
#   target_group_arn = aws_lb_target_group.user_dmz_nexus_tg[count.index].arn
#   target_id        = aws_instance.user_dmz_proxy[count.index].id
#   port = 80
# }

resource "aws_lb" "user_dmz_proxy_lb" {
  count              = 2
  name               = "user-dmz-proxy-lb-${local.az_ac[count.index]}"
  load_balancer_type = "network"
  internal = false
  subnets = [aws_subnet.user_dmz_pri_subnet[count.index].id]
  security_groups = [aws_security_group.dmz_elb_sg[0].id]
}

resource "aws_lb_listener" "user_proxy_lb_listener" {
  count             = 2
  load_balancer_arn = aws_lb.user_dmz_proxy_lb[count.index].arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_dmz_proxy_tg[count.index].arn
  }
}

resource "aws_lb_listener" "user_nexus_lb_listener" {
  count             = 2
  load_balancer_arn = aws_lb.user_dmz_proxy_lb[count.index].arn
  port              = "9999"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_dmz_proxy_tg[count.index].arn
  }
}

resource "aws_lb_target_group" "dev_dmz_proxy_tg" {
  count       = 2
  name        = "dev-dmz-target-group-${local.az_ac[count.index]}"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id = aws_vpc.project_vpc[1].id
}
resource "aws_lb_target_group_attachment" "dev_dmz_proxy_tg_att" {
  count            = 2
  target_group_arn = aws_lb_target_group.dev_dmz_proxy_tg[count.index].arn
  target_id        = aws_instance.dev_dmz_proxy[count.index].id
  port = 80
}

resource "aws_lb_target_group" "dev_dmz_nexus_tg" {
  count       = 2
  name        = "dev-nexus-target-group-${local.az_ac[count.index]}"
  port        = 5000
  protocol    = "TCP"
  target_type = "ip"
  vpc_id = local.user_dev_vpc[1]
}

# resource "aws_lb_target_group_attachment" "dev_dmz_to_nexus_att" {
#   count            = 2
#   target_group_arn = aws_lb_target_group.dev_dmz_nexus_tg[count.index].arn
#   target_id        = aws_instance.dev_dmz_proxy[count.index].id
#   port = 80
# }


resource "aws_lb" "dev_dmz_proxy_lb" {
  count              = 2
  name               = "dev-dmz-proxy-lb-${local.az_ac[count.index]}"
  load_balancer_type = "network"
  internal = false
  subnets = [aws_subnet.dev_dmz_pri_subnet[count.index].id]
  security_groups = [aws_security_group.dmz_elb_sg[1].id]
}

resource "aws_lb_listener" "dev_proxy_lb_listener" {
  count             = 2
  load_balancer_arn = aws_lb.dev_dmz_proxy_lb[count.index].arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_proxy_tg[count.index].arn
  }
}

resource "aws_lb_listener" "dev_nexus_lb_listener" {
  count             = 2
  load_balancer_arn = aws_lb.dev_dmz_proxy_lb[count.index].arn
  port              = "9999"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_proxy_tg[count.index].arn
  }
}

################################################################################
resource "aws_lb_target_group" "nexus_tg" {
  name        = "shared-nexus-ext-lb-tg"
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.project_vpc[2].id
}

resource "aws_lb_target_group_attachment" "nexus_tg_att" {
    target_group_arn = aws_lb_target_group.nexus_tg.arn
    target_id = aws_instance.shared_nexus.id
    port = 22
}

resource "aws_lb" "shared_ext_lb" {
  name                = "shared-ext-lb"
  internal            = true
  load_balancer_type  = "network"
  subnets             = [aws_subnet.shared_pri_subnet[0].id]
  security_groups     = [ aws_security_group.shared_ext_lb_sg.id ]

  tags = {  
    Name = "shared-ext-lb"
    }
}
resource "aws_lb_listener" "nexus_listener" {
  load_balancer_arn = aws_lb.shared_ext_lb.arn
  port              = "5555"
  protocol          = "TCP"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  # alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nexus_tg.arn
  }
}

resource "aws_lb_target_group" "shared_int_tg" {
  count       = length(local.shared_ec2_name)
  name        = local.shared_ec2_name[count.index]
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.project_vpc[2].id
}

resource "aws_lb_target_group_attachment" "shared_monitoring_att" {
    count            = 2 
    target_group_arn = aws_lb_target_group.shared_int_tg[count.index].arn
    target_id        = aws_instance.shared_monitoring[count.index].id
    port             = 22 
}

resource "aws_lb_target_group_attachment" "shared_elk_att" { 
    target_group_arn = aws_lb_target_group.shared_int_tg[2].arn
    target_id        = aws_instance.shared_elk.id
    port             = 22 
}

resource "aws_lb" "shared_int" {
  name                = "shared-int-lb"
  internal            = true
  load_balancer_type  = "network"
  subnets             = [aws_subnet.shared_pri_subnet[0].id]
  security_groups     = [ aws_security_group.shared_int_lb_sg.id ]

  tags = {
    Name = "shared-int-lb"
  }
}
resource "aws_lb_listener" "shared_int_linsten01" {
  count             = 2
  load_balancer_arn = aws_lb.shared_int.arn
  port              = local.shared_ports[count.index]
  protocol          = "TCP"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  # alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shared_int_tg[count.index].arn
  }
}  

resource "aws_lb_listener" "shared_int_listen02" {
  load_balancer_arn = aws_lb.shared_int.arn
  port              = local.shared_ports[2]
  protocol          = "TCP"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  # alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shared_int_tg[2].arn
  }
}  