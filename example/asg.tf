###
# 1. Web Instance ASG
###
resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg" 
  min_size             = 1 
  desired_capacity     = 2
  max_size             = 4
  target_group_arns = [ aws_lb_target_group.ext-tg.arn ]

  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.web.name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier  = aws_subnet.web[*].id

  lifecycle {
    create_before_destroy = true
  }

  tag {
      key = "Name"
      value = "Web"
      propagate_at_launch = true
    }
  dynamic "tag" {
    for_each = var.web_asg_tags
    content {
      key    =  tag.key
      value   =  tag.value
      propagate_at_launch =  true
    }
  }

  depends_on = [ 
    aws_alb.external_lb,
    aws_ami_from_instance.ami_web
   ]
}

# 2. APP Instance ASG
###
resource "aws_autoscaling_group" "app" {
  name = "${aws_launch_configuration.app.name}-asg" 
  min_size             = 1 
  desired_capacity     = 2
  max_size             = 4
  target_group_arns = [ aws_lb_target_group.int-tg.arn ]

  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.app.name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier  = aws_subnet.app[*].id

  lifecycle {
    create_before_destroy = true
  }
  
  tag {
      key ="Name"
      value = "APP"
      propagate_at_launch = true
    }
  dynamic "tag" {
    for_each = var.app_asg_tags

    content {
      key    =  tag.key
      value   =  tag.value
      propagate_at_launch =  true
    }
  }
  
  depends_on = [ 
    aws_alb.internal_lb,
    aws_ami_from_instance.ami_app
  ]
}
