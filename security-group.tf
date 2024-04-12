###
# 1. Instance
### 

resource "aws_security_group" "user_dmz_proxy_sg" {
  name = "user_dmz_proxy_sg" 
  description = "Security Group for ngninx_proxy_instance in user_dmz" 
  vpc_id = aws_vpc.project_vpc["user_dmz_vpc"].id

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  security_groups   = [aws_security_group.user_dmz_elb_sg.id]
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
}

resource "aws_security_group" "user_dmz_elb_sg" {
  name = "user_dmz_elb_sg" 
  description = "Security Group for load_balancer in user_dmz" 
  vpc_id = aws_vpc.project_vpc["user_dmz_vpc"].id

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
    Name = "user_dmz_elb_sg"
  }
}

resource "aws_security_group" "dev_dmz_proxy_sg" {
  name = "dev_dmz_proxy_sg" 
  description = "Security Group for ngninx_proxy_instance in dev_dmz" 
  vpc_id = aws_vpc.project_vpc["dev_dmz_vpc"].id

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  security_groups   = [aws_security_group.dev_dmz_elb_sg.id]
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "dev_dmz_proxy_sg"
  }
}

resource "aws_security_group" "dev_dmz_elb_sg" {
  name = "dev_dmz_elb_sg" 
  description = "Security Group for load_balancer in dev_dmz" 
  vpc_id = aws_vpc.project_vpc["dev_dmz_vpc"].id

  ingress {
  from_port     = 80
  to_port       = 80
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  ingress {
  from_port     = 8888
  to_port       = 8888
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
    Name = "dev_dmz_elb_sg"
  }
}

resource "aws_security_group" "shared_nexus_sg" { 
  name = "shared_nexus_sg" 
  description = "Security Group for shared_nexus" 
  vpc_id = aws_vpc.project_vpc["shared_vpc"].id

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
  vpc_id = aws_vpc.project_vpc["shared_vpc"].id

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
  vpc_id = aws_vpc.project_vpc["shared_vpc"].id

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
  vpc_id = aws_vpc.project_vpc["shared_vpc"].id

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



resource "aws_security_group" "product_eks_sg" { 
  name = "product_eks_sg" 
  description = "Security Group for product_eks" 
  vpc_id = aws_vpc.project_vpc["product_vpc"].id

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
    Name = "product_eks_sg"
  }
}

resource "aws_security_group" "testdev_eks_sg" { 
  name = "testdev_eks_sg" 
  description = "Security Group for testdev_eks" 
  vpc_id = aws_vpc.project_vpc["testdev_vpc"].id

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
    Name = "product_eks_sg"
  }
}