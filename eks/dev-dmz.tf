###
# 1. vpc
###
resource "aws_vpc" "dev_dmz" {
  cidr_block = local.dev_dmz_vpc_cidr
  tags = local.dev_dmz_tags
    
  enable_dns_hostnames      = true
  enable_dns_support        = true
}
###
# 2. subnets
###
resource "aws_subnet" "dev_dmz_nat" {
  count               = length(local.azs)
  vpc_id              = aws_vpc.dev_dmz.id
  cidr_block          = cidrsubnet(local.dev_dmz_vpc_cidr, 8, count.index+10)
  availability_zone   = element(local.azs, count.index)

  tags = {
    Name = "${local.dev_dmz_name}-subnet-nat-0${count.index+1}"
  }
  map_public_ip_on_launch = true
}
resource "aws_subnet" "dev_dmz_lb" {
  count               = length(local.azs)
  vpc_id              = aws_vpc.dev_dmz.id
  cidr_block          = cidrsubnet(local.dev_dmz_vpc_cidr, 8, count.index+100)
  availability_zone   = element(local.azs, count.index)

  tags = {
    Name = "${local.dev_dmz_name}-subnet-lb-0${count.index+1}"
  }
  map_public_ip_on_launch = true
}
resource "aws_subnet" "dev_dmz_proxy" {
  count               = length(local.azs)
  vpc_id              = aws_vpc.dev_dmz.id
  cidr_block          = cidrsubnet(local.dev_dmz_vpc_cidr, 8, count.index+150)
  availability_zone   = element(local.azs, count.index)

  tags = {
    Name = "${local.dev_dmz_name}-subnet-proxy-0${count.index+1}"
  }
}
resource "aws_subnet" "dev_dmz_tgw" {
  count               = length(local.azs)
  vpc_id              = aws_vpc.dev_dmz.id
  cidr_block          = cidrsubnet(local.dev_dmz_vpc_cidr, 8, count.index+200)
  availability_zone   = element(local.azs, count.index)

  tags = {
    Name = "${local.dev_dmz_name}-subnet-tgw-0${count.index+1}"
  }
}
###
# 3. gateways
###
resource "aws_eip" "dev_dmz_eip" {
  # count   = length(local.azs)
  vpc     = true

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_internet_gateway" "dev_dmz_igw" {
  vpc_id = aws_vpc.dev_dmz.id 
  
  tags = {
    Name = "${local.dev_dmz_name}-igw"
 }
}
resource "aws_nat_gateway" "dev_dmz_ngw" {
  # count               = length(local.azs)
  # allocation_id       = element(aws_eip.dev_dmz_eip[*].id,count.index)
  # subnet_id           = element(aws_subnet.dev_dmz_nat[*].id, count.index)
  allocation_id = aws_eip.dev_dmz_eip.id
  subnet_id = aws_subnet.dev_dmz_nat[0].id
  tags = {
    # Name = "${local.dev_dmz_name}-ngw-${count.index+1}"
    Name = "${local.dev_dmz_name}-ngw"
  }
 depends_on = [
    aws_internet_gateway.dev_dmz_igw,
    aws_eip.dev_dmz_eip
  ]
}
###
# 4. routing table
###
resource "aws_route_table" "dev_dmz_public_rt" {
  vpc_id = aws_vpc.dev_dmz.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_dmz_igw.id
  }
  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }


  tags = {
    Name = "${local.dev_dmz_name}-public-RT"
  }
  depends_on = [
    aws_internet_gateway.dev_dmz_igw,
    aws_ec2_transit_gateway.main,
    aws_ec2_transit_gateway_vpc_attachment.dev_dmz
  ]
}
resource "aws_route_table" "dev_dmz_proxy_rt" {
  vpc_id = aws_vpc.dev_dmz.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev_dmz_ngw.id
  }
  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name = "${local.dev_dmz_name}-proxy-RT"
  }
  depends_on = [
    aws_nat_gateway.dev_dmz_ngw,
    aws_ec2_transit_gateway.main,
    aws_ec2_transit_gateway_vpc_attachment.dev_dmz
  ]
}
resource "aws_route_table" "dev_dmz_tgw_rt" {
  vpc_id = aws_vpc.dev_dmz.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev_dmz_ngw.id
  }

  tags = {
    Name = "${local.dev_dmz_name}-tgw-RT"
  }
  depends_on = [
    aws_nat_gateway.dev_dmz_ngw,
    aws_ec2_transit_gateway.main
  ]
}
resource "aws_route_table_association" "dev_dmz_nat_subnet_asso" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.dev_dmz_nat[*].id, count.index)
  route_table_id = aws_route_table.dev_dmz_public_rt.id

  depends_on = [
    aws_subnet.dev_dmz_nat,
    aws_route_table.dev_dmz_public_rt
  ]
}
resource "aws_route_table_association" "dev_dmz_lb_subnet_asso" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.dev_dmz_lb[*].id, count.index)
  route_table_id = aws_route_table.dev_dmz_public_rt.id

  depends_on = [
    aws_subnet.dev_dmz_lb,
    aws_route_table.dev_dmz_public_rt
  ]
}
resource "aws_route_table_association" "dev_dmz_proxy_subnet_asso" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.dev_dmz_proxy[*].id, count.index)
  route_table_id = aws_route_table.dev_dmz_proxy_rt.id
  
  depends_on = [
    aws_route_table.dev_dmz_proxy_rt
  ]
}
resource "aws_route_table_association" "dev_dmz_tgw_subnet_asso" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.dev_dmz_tgw[*].id, count.index)
  route_table_id = aws_route_table.dev_dmz_tgw_rt.id
  
  depends_on = [
    aws_route_table.dev_dmz_tgw_rt
  ]
}
###
# 5. security groups
###
resource "aws_security_group" "dev_dmz_lb" {
  name = "dev_dmz_lb_sg" 
  description = "Security Group for dev_dmz_lb" 
  vpc_id = aws_vpc.dev_dmz.id

  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  ingress {
    from_port     = 443
    to_port       = 443
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
  tags = merge(var.dmz_tags,var.dev_tags,
    {
      Name = "dev_dmz_lb"
    }
  )
}
resource "aws_security_group_rule" "dev_dmz-prom_grafa" {
  for_each                  = { for k, v in var.shared_int : k => v if lookup(v, "svc_port", null) != null }
  security_group_id         = aws_security_group.dev_dmz_lb.id
  type                      = "ingress"
  cidr_blocks               = ["0.0.0.0/0"]
  protocol                  = "tcp"
  from_port                 = each.value.dmz_listen
  to_port                   = each.value.dmz_listen
}
resource "aws_security_group" "dev_dmz_proxy" {
  name = "dev_dmz_proxy_sg" 
  description = "Security Group for dev_dmz_proxy" 
  vpc_id = aws_vpc.dev_dmz.id

  ingress {
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks = aws_subnet.nexus[*].cidr_block
  }
  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    security_groups = [aws_security_group.dev_dmz_lb.id]
  }
  ingress {
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    security_groups = [aws_security_group.dev_dmz_lb.id]
  }

  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = merge(var.dmz_tags,var.dev_tags,
    {
      Name = "dev_dmz_proxy-sg"
    }
  )
}
###
# 6. instaces
###
# resource "aws_instance" "dev_dmz_proxy" {
#   ami = data.aws_ami.amazon_linux_2023.id
#   instance_type = "t2.small" 
#   vpc_security_group_ids = [aws_security_group.dev_dmz_proxy.id]
#   key_name = aws_key_pair.terraform_key.key_name
#   subnet_id = aws_subnet.dev_dmz_proxy[0].id
#   associate_public_ip_address = false
#   user_data = <<-EOF
#   #!/bin/bash
#   dnf install -y nginx
#   systemctl enable --now nginx
#   echo "It is dev dmz proxy server" > /user/share/nginx/html/index.html
#   EOF
#   tags = merge(var.dmz_tags,var.dev_tags,
#     {
#       Name = "dev_dmz_proxy"
#     }
#   )

#   depends_on = [ aws_security_group.dev_dmz_proxy ]
# }
###
# 7. loadbalancer
###
resource "aws_lb_target_group" "dev_dmz_proxy" {
  name                = "dev-dmz-proxy-target-group"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.dev_dmz.id
}
resource "aws_lb_target_group" "dev_dmz_https_proxy" {
  name                = "dev-dmz-https-proxy-target-group"
  port        = 443
  protocol    = "TCP"
  vpc_id      = aws_vpc.dev_dmz.id
}
resource "aws_lb_target_group" "dev_dmz_nexus" {
  name        = "dev-dmz-nexus-target-group"
  port        = 5000
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.dev_dmz.id
}
resource "aws_lb_target_group" "dev_dmz_prom-grafa" {
  for_each    = { for k, v in var.shared_int : k => v if lookup(v, "listener", null) != null }
  name        = "dev-dmz-${each.value.svc_name}-target-group"
  port        = each.value.listener
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.dev_dmz.id
}

resource "aws_lb" "dev_dmz_lb" {
  name                = "dev-dmz-lb"
  internal            = false
  load_balancer_type  = "network"
  subnets             = aws_subnet.dev_dmz_lb[*].id
  security_groups     = [ aws_security_group.dev_dmz_lb.id ]

  tags = merge( var.dmz_tags,var.dev_tags,
    {
      Name = "dev-dmz-lb"
    }
  )
}
resource "aws_lb_listener" "dev_dmz_lb_proxy" {
  load_balancer_arn = aws_lb.dev_dmz_lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_proxy.arn
  }
}
resource "aws_lb_listener" "dev_dmz_lb_https_proxy" {
  load_balancer_arn = aws_lb.dev_dmz_lb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_https_proxy.arn
  }
}
resource "aws_lb_listener" "dev_dmz_lb_nexus" {
  load_balancer_arn = aws_lb.dev_dmz_lb.arn
  port              = "9999"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_nexus.arn
  }
}
resource "aws_lb_listener" "dev_dmz_lb_prom-grafa" {
  for_each          = { for k, v in var.shared_int : k => v if lookup(v, "dmz_listen", null) != null }
  load_balancer_arn = aws_lb.dev_dmz_lb.arn
  port              = each.value.dmz_listen
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_dmz_prom-grafa[each.key].arn
  }
}
