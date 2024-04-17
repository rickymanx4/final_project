##############################################################################
################################## 1.(user/dev)_dmz_sg #######################
##############################################################################

################################ a. dmz_proxy_sg ################################
resource "aws_security_group" "dmz_proxy_sg" {
  count       = 2
  name        = "${local.names[count.index]}_proxy_sg" 
  description = "Security Group for ngninx_proxy_instance in dmz" 
  vpc_id      = local.user_dev_vpc[count.index]

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  cidr_blocks   = ["10.100.0.0/16"]
  }

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  security_groups = [aws_security_group.dmz_elb_sg[count.index].id]
  }  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.names[count.index]}_proxy_sg"
  }
  depends_on = [ aws_security_group.dmz_elb_sg ]
}

################################ b. dmz_elb_sg ################################

resource "aws_security_group" "dmz_elb_sg" {
  count       = 2
  name        = "${local.names[count.index]}_elb_sg" 
  description = "Security Group for load_balancer in dmz" 
  vpc_id      = local.user_dev_vpc[count.index]

  ingress {
  from_port     = local.dmz_lb_ports[1]
  to_port       = local.dmz_lb_ports[1]
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
  from_port     = local.dmz_proxy_ports[0]
  to_port       = local.dmz_proxy_ports[0]
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }  

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  } 
  tags = {
    Name = "${local.names[count.index]}_elb_sg"
  }
}

# resource "aws_security_group_rule" "dev_dmz_lb" {
#   security_group_id = aws_security_group.dmz_elb_sg[1].id
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
#   protocol          = "tcp"
#   from_port         = local.dmz_lb_ports[1]
#   to_port           = local.dmz_lb_ports[1]
# }

# resource "aws_security_group_rule" "user_dmz_proxy_sg_01" {
#   count             = 2
#   security_group_id = aws_security_group.dmz_elb_sg[count.index].id
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
#   protocol          = "tcp"
#   from_port         = local.dmz_proxy_ports[0]
#   to_port           = local.dmz_proxy_ports[0]
# }

# resource "aws_security_group_rule" "dev_dmz_proxy_sg_02" {
#   count             = 2
#   security_group_id = aws_security_group.dmz_elb_sg[count.index].id
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
#   protocol          = "tcp"
#   from_port         = local.dmz_proxy_ports[1]
#   to_port           = local.dmz_proxy_ports[1]
# }
##############################################################################
################################## 2. shared_sg ##############################
##############################################################################

################################ a. nexus_sg ################################

resource "aws_security_group" "shared_nexus_sg" { 
  name = "shared_nexus_sg" 
  description = "Security Group for shared_nexus" 
  vpc_id = aws_vpc.project_vpc[2].id

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_ext_lb_sg.id]
  }

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  security_groups   = [aws_security_group.shared_ext_lb_sg.id]
  }

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "shared_nexus_sg"
  }
}

################################ b. monitoring_sg ################################

resource "aws_security_group" "shared_monitoring_sg" { 
  name = "shared_monitoring_sg" 
  description = "Security Group for shared_monitoring" 
  vpc_id = aws_vpc.project_vpc[2].id

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb_sg.id]
  }

  ingress {
  from_port     = 9090
  to_port       = 9090
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb_sg.id]
  }

  ingress {
  from_port     = 3000
  to_port       = 3000
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb_sg.id]
  }

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "shared_monitoring_sg"
  }
}

################################ c. elk_sg ################################

resource "aws_security_group" "shared_elk_sg" { 
  name = "shared_elk_sg" 
  description = "Security Group for shared_elk" 
  vpc_id = aws_vpc.project_vpc[2].id

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb_sg.id]
  }

  ingress {
  from_port     = 5044
  to_port       = 5044
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb_sg.id]
  }

  ingress {
  from_port     = 5601
  to_port       = 5601
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb_sg.id]
  }

  ingress {
  from_port     = 9000
  to_port       = 9000
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb_sg.id]
  }
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "shared_elk_sg"
  }
}

################################ d. eks_sg ################################

resource "aws_security_group" "shared_eks_sg" { 
  name = "shared_eks_sg" 
  description = "Security Group for shared_eks" 
  vpc_id = aws_vpc.project_vpc[2].id
  
  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb_sg.id]
  }

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb_sg.id]
  }

  ingress {
  from_port     = 6000
  to_port       = 6000
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb_sg.id]
  }

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "shared_eks_sg"
  }
}

################################ e. loadbalancer_sg ################################

resource "aws_security_group" "shared_ext_lb_sg" { 
  name = "shared_ext_lb_sg" 
  description = "Security Group for shared_ext_lb_sg" 
  vpc_id = aws_vpc.project_vpc[2].id

  ingress {
  from_port     = 5555
  to_port       = 5555
  protocol      = "tcp"
  cidr_blocks = [var.vpc[1]]
  }

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "shared_ext_lb_sg"
  }
}

resource "aws_security_group" "shared_int_lb_sg" { 
  name = "shared_int_lb_sg" 
  description = "Security Group for shared_int_lb_sg" 
  vpc_id = aws_vpc.project_vpc[2].id

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "shared_int_lb_sg"
  }
}

resource "aws_security_group_rule" "shared_int_lb" {
  security_group_id = aws_security_group.shared_int_lb_sg.id
  type = "ingress"
  count = 4
  source_security_group_id = aws_security_group.shared_nexus_sg.id
  protocol = "tcp"
  from_port = local.shared_int_ports[count.index]
  to_port = local.shared_int_ports[count.index]
}

##############################################################################
########################### 3. (product/testdev)_zone_sg#######################
##############################################################################

################################ a. eks_sg ################################

resource "aws_security_group" "node_sg" { 
  count       = 2  
  name        = "${local.names[count.index + 3]}_node_sg" 
  description = "Security Group for eks" 
  vpc_id = local.prod_test_vpc[count.index]

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  cidr_blocks   = ["10.100.0.0/16"]
  }  

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  security_groups = [aws_security_group.prodtest_int_lb_sg[count.index].id]
  }

  ingress {
  from_port     = 9100
  to_port       = 9100
  protocol      = "tcp"
  security_groups = [aws_security_group.prodtest_int_lb_sg[count.index].id]
  }  

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.names[count.index + 3]}_node_sg"
  }
}

################################ b. rds_sg ################################

resource "aws_security_group" "rds_sg" { 
  count       = 2
  name        = "${local.names[count.index + 3]}_rds_sg" 
  description = "Security Group for rds" 
  vpc_id = local.prod_test_vpc[count.index]

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  cidr_blocks   = ["10.100.0.0/16"]
  }  

  ingress {
  from_port     = 3306
  to_port       = 3306
  protocol      = "tcp"
  security_groups = [aws_security_group.prodtest_int_lb_sg[count.index].id]
  }
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.names[count.index + 3]}_rds_sg"
  }
}

################################ c. elb_sg ################################

resource "aws_security_group" "prodtest_ext_sg" {
  count       = 2
  name        = "${local.names[count.index + 3]}_ext_sg" 
  description = "Security Group for load_balancer in prodtest_ext" 
  vpc_id      = local.prod_test_vpc[count.index]

  ingress {
  from_port     = local.prodtest_lb_ports[count.index]
  to_port       = local.prodtest_lb_ports[count.index]
  protocol      = "tcp"
  cidr_blocks   = [var.vpc[count.index]]
  }

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  } 
  tags = {
    Name = "${local.names[count.index + 3 ]}_ext_sg"
  }
}

resource "aws_security_group" "prodtest_int_lb_sg" { 
  count       = 2
  name = "${local.names[count.index + 3]}_int_sg" 
  description = "Security Group for load_balancer in prodtest_int" 
  vpc_id = local.prod_test_vpc[count.index]

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.names[count.index + 3]}_int_sg"
  }
}

resource "aws_security_group_rule" "product_int_lb" {
  security_group_id = aws_security_group.prodtest_int_lb_sg[0].id
  type = "ingress"
  count = 4
  source_security_group_id = aws_security_group.prodtest_ext_sg[0].id
  protocol = "tcp"
  from_port = local.product_int_ports[count.index]
  to_port = local.product_int_ports[count.index]
}

resource "aws_security_group_rule" "testdev_int_lb" {
  security_group_id = aws_security_group.prodtest_int_lb_sg[1].id
  type = "ingress"
  count = 4
  source_security_group_id = aws_security_group.prodtest_ext_sg[1].id
  protocol = "tcp"
  from_port = local.testdev_int_ports[count.index]
  to_port = local.testdev_int_ports[count.index]
}