###
# 1. Instance
### 

resource "aws_security_group" "dmz_proxy_sg" {
  count       = 2
  name        = "${local.names[count.index]}_proxy_sg" 
  description = "Security Group for ngninx_proxy_instance in dmz" 
  vpc_id      = local.user_dev_vpc[count.index]

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  security_groups   = [aws_security_group.dmz_elb_sg[count.index].id]
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "user_dmz_proxy_sg"
  }
  depends_on = [ aws_security_group.dmz_elb_sg ]
}

resource "aws_security_group" "dmz_elb_sg" {
  count       = 2
  name        = "${local.names[count.index]}_elb_sg" 
  description = "Security Group for load_balancer in dmz" 
  vpc_id      = local.user_dev_vpc[count.index]

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
  from_port     = 9999
  to_port       = 9999
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
    Name = "${local.user_dev[count.index]}_elb_sg"
  }
}

# resource "aws_security_group" "dev_dmz_proxy_sg" {
#   name = "dev_dmz_proxy_sg" 
#   description = "Security Group for ngninx_proxy_instance in dev_dmz" 
#   vpc_id = aws_vpc.project_vpc[1].id

#   ingress {
#   from_port     = 80
#   to_port       = 80
#   protocol      = "tcp"
#   security_groups   = [aws_security_group.dev_dmz_elb_sg.id]
#   }
  
#   egress {
#   from_port     = 0
#   to_port       = 0
#   protocol      = "-1"
#   cidr_blocks   = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "dev_dmz_proxy_sg"
#   }
# }

# resource "aws_security_group" "dev_dmz_elb_sg" {
#   name = "dev_dmz_elb_sg" 
#   description = "Security Group for load_balancer in dev_dmz" 
#   vpc_id = aws_vpc.project_vpc[1].id

#   ingress {
#   from_port     = 80
#   to_port       = 80
#   protocol      = "tcp"
#   cidr_blocks   = ["0.0.0.0/0"]
#   }
#   ingress {
#   from_port     = 8888
#   to_port       = 8888
#   protocol      = "tcp"
#   cidr_blocks   = ["0.0.0.0/0"]
#   }  
  
#   egress {
#   from_port     = 0
#   to_port       = 0
#   protocol      = "-1"
#   cidr_blocks   = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "dev_dmz_elb_sg"
#   }
# }

resource "aws_security_group" "shared_nexus_sg" { 
  name = "shared_nexus_sg" 
  description = "Security Group for shared_nexus" 
  vpc_id = aws_vpc.project_vpc[2].id

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
  from_port     = 80
  to_port       = 80
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
    Name = "shared_nexus_sg"
  }
}

resource "aws_security_group" "shared_monitoring_sg" { 
  name = "shared_monitoring_sg" 
  description = "Security Group for shared_monitoring" 
  vpc_id = aws_vpc.project_vpc[2].id

  ingress {
  from_port     = 9090
  to_port       = 9090
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
  from_port     = 3000
  to_port       = 3000
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
    Name = "shared_monitoring_sg"
  }
}

resource "aws_security_group" "shared_elk_sg" { 
  name = "shared_elk_sg" 
  description = "Security Group for shared_elk" 
  vpc_id = aws_vpc.project_vpc[2].id

  ingress {
  from_port     = 5044
  to_port       = 5044
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
  from_port     = 5601
  to_port       = 5601
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
  from_port     = 9000
  to_port       = 9000
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
    Name = "shared_elk_sg"
  }
}
resource "aws_security_group" "shared_eks_sg" { 
  name = "shared_eks_sg" 
  description = "Security Group for shared_eks" 
  vpc_id = aws_vpc.project_vpc[2].id

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
  from_port     = 6000
  to_port       = 6000
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
    Name = "shared_eks_sg"
  }
}



resource "aws_security_group" "eks_sg" { 
  count       = 2  
  name        = "${local.prod_test[count.index]}_eks_sg" 
  description = "Security Group for eks" 
  vpc_id = local.prod_test_vpc[count.index]

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
  from_port     = 6000
  to_port       = 6000
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  ingress {
  from_port     = 9100
  to_port       = 9100
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
    Name = "${local.prod_test[count.index]}_eks_sg"
  }
}

resource "aws_security_group" "rds_sg" { 
  count       = 2
  name        = "${local.prod_test[count.index]}_rds_sg" 
  description = "Security Group for rds" 
  vpc_id = local.prod_test_vpc[count.index]

  ingress {
  from_port     = 3306
  to_port       = 3306
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
    Name = "product_rds_sg"
  }
}

# resource "aws_security_group" "testdev_eks_sg" { 
#   name = "testdev_eks_sg" 
#   description = "Security Group for testdev_eks" 
#   vpc_id = aws_vpc.project_vpc[4].id

#   ingress {
#   from_port     = 80
#   to_port       = 80
#   protocol      = "tcp"
#   cidr_blocks   = ["0.0.0.0/0"]
#   }

#   ingress {
#   from_port     = 6000
#   to_port       = 6000
#   protocol      = "tcp"
#   cidr_blocks   = ["0.0.0.0/0"]
#   }
#   ingress {
#   from_port     = 9100
#   to_port       = 9100
#   protocol      = "tcp"
#   cidr_blocks   = ["0.0.0.0/0"]
#   }  
#   egress {
#   from_port     = 0
#   to_port       = 0
#   protocol      = "-1"
#   cidr_blocks   = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "product_eks_sg"
#   }
# }

# resource "aws_security_group" "testdev_rds_sg" { 
#   name = "testdev_rds_sg" 
#   description = "Security Group for testdev_rds" 
#   vpc_id = aws_vpc.project_vpc[4].id

#   ingress {
#   from_port     = 3306
#   to_port       = 3306
#   protocol      = "tcp"
#   cidr_blocks   = ["0.0.0.0/0"]
#   }
#   egress {
#   from_port     = 0
#   to_port       = 0
#   protocol      = "-1"
#   cidr_blocks   = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "product_rds_sg"
#   }
# }