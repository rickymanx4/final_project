###
# 1. External-Loadb-Balancer
###
resource "aws_alb" "external_lb" {
  name               = "ext-lb"
  load_balancer_type = "application"
  internal = false
  subnets = aws_subnet.public[*].id
  security_groups = [aws_security_group.project_ext-lb.id]
}
resource "aws_lb_listener" "ext_listener" {
  load_balancer_arn = aws_alb.external_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ext-tg.arn
  }
}
resource "aws_lb_target_group" "ext-tg" {
  name        = "ext-lb-target-group"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.project_vpc.id
  health_check {
    matcher = "200,301,302"
    path = "/"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout             = 5   # 5초의 타임아웃
    interval            = 30  # 30초 간격으로 헬스 체크
  }
}
# resource "aws_lb_target_group_attachment" "ext" {
#     target_group_arn = aws_lb_target_group.ext-tg.arn
#     target_id = aws_instance.project_web.id
#     port = 5000
# }

###
# 2. internal-Loadb-Balancer
###
resource "aws_alb" "internal_lb" {
  name               = "int-lb"
  internal           = true
  load_balancer_type = "application"
  subnets = aws_subnet.web[*].id
  security_groups = [aws_security_group.project_int-lb.id]
}
resource "aws_lb_listener" "int_listener" {
  load_balancer_arn = "${aws_alb.internal_lb.arn}"
  port              = "5000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.int-tg.arn}"
  }
}
resource "aws_lb_target_group" "int-tg" {
  name        = "int-lb-target-group"
  port        = 5000
  protocol    = "HTTP"
  # target_type = "ip"
  vpc_id      = aws_vpc.project_vpc.id
  health_check {
    matcher = "200,301,302"
    path = "/"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout             = 5   # 5초의 타임아웃
    interval            = 30  # 30초 간격으로 헬스 체크
  }
}
# resource "aws_lb_target_group_attachment" "int" {
#     target_group_arn = aws_lb_target_group.int-tg.arn
#     target_id = aws_instance.project_app.id
#     port = 5000
# }

