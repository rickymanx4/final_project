###
# 1. Instance
### 
resource "aws_security_group" "project_bastion" {
  name = "project_bastion" 
  description = "Security Group for Bastion" 
  vpc_id = aws_vpc.project_vpc.id

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
  }
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
    Name = "project_Public"
  }
}

resource "aws_security_group" "project_web" {
  name = "project_web" 
  description = "Security Group for Web Layer Instance" 
  vpc_id = aws_vpc.project_vpc.id

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  security_groups   = [aws_security_group.project_bastion.id]
  }
  ingress {
  from_port     = 9100
  to_port       = 9100
  protocol      = "tcp"
  security_groups   = [aws_security_group.project_bastion.id]
  }
  ingress {
    description = "flask service"
    from_port     = 5000 # 필요에 따라 수정 가능
    to_port       = 5000 # 필요에 따라 수정 가능
    protocol      = "tcp"
    security_groups   = [aws_security_group.project_ext-lb.id]
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "project_Web"
  }
}

resource "aws_security_group" "project_app" {
  name = "project_app" 
  description = "Security Group for APP Layer Instance" 
  vpc_id = aws_vpc.project_vpc.id

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  security_groups   = [aws_security_group.project_bastion.id]
  }
  ingress {
  from_port     = 9100
  to_port       = 9100
  protocol      = "tcp"
  security_groups   = [aws_security_group.project_bastion.id]
  }
  ingress {
    description = "flask service"
    from_port     = 5000 # 필요에 따라 수정 가능
    to_port       = 5000 # 필요에 따라 수정 가능
    protocol      = "tcp"
    security_groups   = [aws_security_group.project_int-lb.id]
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "project_APP"
  }
}
###
# 2. Load-Balancer
###
resource "aws_security_group" "project_ext-lb" {
  name = "project_ext-lb" 
  description = "Security Group for External Load Balancer" 
  vpc_id = aws_vpc.project_vpc.id

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
    Name = "project_Ext-LB"
  }
}

resource "aws_security_group" "project_int-lb" {
  name = "project_int-lb" 
  description = "Security Group for Internal Load Balancer" 
  vpc_id = aws_vpc.project_vpc.id

  ingress {
  from_port     = 80 # 필요에 따라 수정 가능
  to_port       = 80 # 필요에 따라 수정 가능
  protocol      = "tcp"
  security_groups = [aws_security_group.project_web.id]
  }
  ingress {
    description = "flask service"
    from_port     = 5000 # 필요에 따라 수정 가능
    to_port       = 5000 # 필요에 따라 수정 가능
    protocol      = "tcp"
    security_groups   = [aws_security_group.project_web.id]
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "project_Int-LB"
  }
}
###
# 3. DB
###
resource "aws_security_group" "project_db" {
  name = "project_db" 
  description = "Security Group for RDS DB" 
  vpc_id = aws_vpc.project_vpc.id

  ingress {
  from_port     = 3306 
  to_port       = 3306
  protocol      = "tcp"
  security_groups   = [aws_security_group.project_web.id]
  }
  ingress {
  from_port     = 3306
  to_port       = 3306
  protocol      = "tcp"
  security_groups   = [aws_security_group.project_app.id]
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "project_DB"
  }
}

###
# 4. EFS
###
resource "aws_security_group" "project_web_efs" {
  name = "project_web_efs" 
  description = "Security Group for Web EFS" 
  vpc_id = aws_vpc.project_vpc.id

  ingress {
  from_port     = 2049
  to_port       = 2049
  protocol      = "tcp"
  security_groups   = [aws_security_group.project_web.id]
  }

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "project_Web_efs"
  }
}

resource "aws_security_group" "project_app_efs" {
  name = "project_app_efs" 
  description = "Security Group for APP EFS" 
  vpc_id = aws_vpc.project_vpc.id

  ingress {
  from_port     = 2049
  to_port       = 2049
  protocol      = "tcp"
  security_groups   = [aws_security_group.project_app.id]
  }
  
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = {
    Name = "project_APP_efs"
  }
}