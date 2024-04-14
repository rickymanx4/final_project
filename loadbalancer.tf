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





