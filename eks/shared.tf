###
# 1. vpc
###
resource "aws_vpc" "shared" {
    cidr_block = local.shared_vpc_cidr
    tags = local.shared_tags
    
    enable_dns_hostnames      = true
    enable_dns_support        = true
}
###
# 2. subnets
###
resource "aws_subnet" "nexus" {
    count               = length(local.azs)
    vpc_id              = aws_vpc.shared.id
    cidr_block          = cidrsubnet(local.shared_vpc_cidr, 8, count.index+10)
    availability_zone   = element(local.azs, count.index)

    tags = {
        Name            = "${local.shared_name}-subnet-nexus-0${count.index+1}"
        Identifier      = "subnet-nexus"
    }
}
resource "aws_subnet" "shared_int" {
    count               = length(local.azs)
    vpc_id              = aws_vpc.shared.id
    cidr_block          = cidrsubnet(local.shared_vpc_cidr, 8, count.index+100)
    availability_zone   = element(local.azs, count.index)

    tags = {
        Name = "${local.shared_name}-subnet-int-0${count.index+1}"
        Identifier      = "subnet-shared-int"
    }
}
resource "aws_subnet" "shared_tgw" {
    count               = length(local.azs)
    vpc_id              = aws_vpc.shared.id
    cidr_block          = cidrsubnet(local.shared_vpc_cidr, 8, count.index+200)
    availability_zone   = element(local.azs, count.index)

    tags = {
        Name = "${local.shared_name}-subnet-tgw-0${count.index+1}"
    }
}
###
# 3. routing table
###
resource "aws_route_table" "nexus" {
  vpc_id = aws_vpc.shared.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name = "${local.shared_name}-nexus-RT"
  }
  depends_on = [
    aws_ec2_transit_gateway.main,
    aws_ec2_transit_gateway_vpc_attachment.shared
  ]
}
resource "aws_route_table_association" "nexus" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.nexus[*].id, count.index)
  route_table_id = aws_route_table.nexus.id

  depends_on = [
    aws_route_table.nexus
    ]
}
resource "aws_route_table" "shared_int" {
  vpc_id = aws_vpc.shared.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name = "${local.shared_name}-int-RT"
  }
  depends_on = [
    aws_ec2_transit_gateway.main,
    aws_ec2_transit_gateway_vpc_attachment.shared
  ]
}
resource "aws_route_table_association" "shared_int" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.shared_int[*].id, count.index)
  route_table_id = aws_route_table.shared_int.id

  depends_on = [
    aws_route_table.shared_int
    ]
}
resource "aws_route_table" "shared_tgw" {
  vpc_id = aws_vpc.shared.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name = "${local.shared_name}-subnet-tgw-RT"
  }
  depends_on = [
    aws_ec2_transit_gateway.main,
    aws_ec2_transit_gateway_vpc_attachment.shared
  ]
}
resource "aws_route_table_association" "shared_tgw" {
  count = length(local.azs)
  subnet_id = element(aws_subnet.shared_tgw[*].id, count.index)
  route_table_id = aws_route_table.shared_tgw.id

  depends_on = [
    aws_route_table.shared_tgw
    ]
}
###
# 4. security groups
###
resource "aws_security_group" "nexus" {
  name = "nexus_sg" 
  description = "Security Group for nexus" 
  vpc_id = aws_vpc.shared.id

  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_ext_lb.id]
  }

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = merge(var.shared_tags,var.dev_tags,
    {
      Name = "nexus_sg"
    }
  )
}
resource "aws_security_group" "shared_ext_lb" {
  name = "shared_ext_lb_sg" 
  description = "Security Group for shared_ext_lb" 
  vpc_id = aws_vpc.shared.id

  ingress {
  from_port     = 5000
  to_port       = 5000
  protocol      = "tcp"
  cidr_blocks   = aws_subnet.dev_dmz_lb[*].cidr_block
  }

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = merge(var.shared_tags,var.dev_tags,
    {
      Name = "shared_ext_lb_sg"
    }
  )
}
resource "aws_security_group_rule" "prom_grafa_listener" {
  for_each                  = { for k, v in var.shared_int : k => v if lookup(v, "listener", null) != null }
  security_group_id         = aws_security_group.shared_ext_lb.id
  type                      = "ingress"
  cidr_blocks               = [ local.dev_dmz_vpc_cidr ]
  protocol                  = "tcp"
  from_port                 = each.value.listener
  to_port                   = each.value.listener
}
resource "aws_security_group" "shared_int_default" {
  name = "shared_shared_int_default_sg" 
  description = "Security Group for shared_int" 
  vpc_id = aws_vpc.shared.id
  ingress {
  from_port     = 22
  to_port       = 22
  protocol      = "tcp"
  security_groups = [aws_security_group.shared_int_lb.id]
  }
  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = merge(var.shared_tags,var.dev_tags,
    {
      Name = "shared_int_default_sg"
    }
  )
}
resource "aws_security_group" "shared_int_prom-grafa" {
  name                      = "shared_int_prom-grafa" 
  description               = "Security Group for shared_int_prom-grafa" 
  vpc_id                    = aws_vpc.shared.id
  tags = merge(var.shared_tags,var.dev_tags,
    {
      Name = "shared_int_prom-grafa_sg"
    }
  )
}
resource "aws_security_group_rule" "prom_grafa" {
  for_each                  = { for k, v in var.shared_int : k => v if lookup(v, "svc_port", null) != null }
  security_group_id         = aws_security_group.shared_int_prom-grafa.id
  type                      = "ingress"
  source_security_group_id  = aws_security_group.shared_ext_lb.id
  protocol                  = "tcp"
  from_port                 = each.value.svc_port
  to_port                   = each.value.svc_port
}
resource "aws_security_group" "shared_int_lb" {
  name = "shared_int_lb_sg" 
  description = "Security Group for shared_int_lb" 
  vpc_id = aws_vpc.shared.id

  egress {
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }
  tags = merge(var.shared_tags,var.dev_tags,
    {
      Name = "shared_int_lb_sg"
    }
  )
}
resource "aws_security_group_rule" "shared_int_lb" {
  for_each                  = { for k, v in var.shared_int : k => v if lookup(v, "port", null) != null }
  security_group_id         = aws_security_group.shared_int_lb.id
  type                      = "ingress"
  source_security_group_id  = aws_security_group.nexus.id
  protocol                  = "tcp"
  from_port                 = each.value.port
  to_port                   = each.value.port
}
###
# 5. instances
###
resource "aws_instance" "nexus" {
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.nexus.id]
  key_name = aws_key_pair.terraform_key.key_name
  subnet_id = aws_subnet.nexus[0].id
  associate_public_ip_address = false

  tags = merge(var.shared_tags,var.dev_tags,
    {
      Name        = "nexus"
    }
  )
  depends_on = [
    aws_subnet.nexus,
    aws_security_group.nexus
  ]
}
resource "aws_instance" "shared_int" {
  for_each         = { for k, v in var.shared_int : k => v if lookup(v, "instance", true) != false }
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = concat(
    [ aws_security_group.shared_int_default.id ],
    [ for k, v in var.shared_int : aws_security_group.shared_int_prom-grafa.id if lookup(v, "svc_port", null) != null]
  )
  iam_instance_profile = each.value.svc_port != null ? aws_iam_instance_profile.prometheus_profile.name : null
  key_name = aws_key_pair.terraform_key.key_name
  subnet_id = aws_subnet.shared_int[0].id
  associate_public_ip_address = false

  tags = merge(var.shared_tags,var.dev_tags,
    {
      Name = each.value.name
    }
  )
  depends_on = [
    aws_lb.shared_ext,
    aws_subnet.shared_int,
    aws_security_group.shared_int_default,
    aws_security_group.shared_int_prom-grafa
  ]
}
###
# 6. loadbalancer
###
resource "aws_lb_target_group" "nexus" {
  name        = "shared-ext-lb-tg"
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.shared.id
}
resource "aws_lb_target_group_attachment" "nexus" {
  target_group_arn = aws_lb_target_group.nexus.arn
  target_id        = aws_instance.nexus.id
  port             = 22
}
resource "aws_lb_target_group" "ext_prom-grafa" {
  for_each         = { for k, v in var.shared_int : k => v if lookup(v, "svc_port", null) != null }
  name             = "shared-ext-${each.value.svc_name}"
  port             = each.value.svc_port
  protocol         = "TCP"
  vpc_id           = aws_vpc.shared.id
}
resource "aws_lb_target_group_attachment" "ext_prom-grafa" {
  for_each          = { for k, v in var.shared_int : k => v if lookup(v, "svc_port", null) != null }
  target_group_arn  = aws_lb_target_group.ext_prom-grafa[each.key].arn
  target_id         = aws_instance.shared_int["prom-grafa"].id
  port              = each.value.svc_port
}
resource "aws_lb" "shared_ext" {
  name                = "shared-ext-lb"
  internal            = true
  load_balancer_type  = "network"
  subnets             = aws_subnet.shared_tgw[*].id
  security_groups     = [ aws_security_group.shared_ext_lb.id ]

  tags = merge( var.shared_tags, var.dev_tags,
    {
      Name = "shared-ext-lb"
    }
  )
}
resource "aws_lb_listener" "nexus" {
  load_balancer_arn = aws_lb.shared_ext.arn
  port              = "5000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nexus.arn
  }
}
resource "aws_lb_listener" "prom-grafa" {
  for_each           = { for k, v in var.shared_int : k => v if lookup(v, "listener", null) != null }
  load_balancer_arn  = aws_lb.shared_ext.arn
  port               = each.value.listener
  protocol           = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ext_prom-grafa[each.key].arn
  }
}
resource "aws_lb_target_group" "shared_int" {
  for_each         = { for k, v in var.shared_int : k => v if lookup(v, "instance", true) != false }
  name        = each.value.name
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.shared.id
}
resource "aws_lb_target_group_attachment" "shared_int" {
    for_each         = { for k, v in var.shared_int : k => v if lookup(v, "instance", true) != false }
    target_group_arn = aws_lb_target_group.shared_int[each.key].arn
    target_id = aws_instance.shared_int[each.key].id
    port = 22
}
resource "aws_lb" "shared_int" {
  name                = "shared-int-lb"
  internal            = true
  load_balancer_type  = "network"
  subnets             = aws_subnet.nexus[*].id
  security_groups     = [ aws_security_group.shared_int_lb.id ]

  tags = merge( var.shared_tags,var.dev_tags,
    {
      Name = "shared-int-lb"
    }
  )
}
resource "aws_lb_listener" "shared_int" {
  for_each         = { for k, v in var.shared_int : k => v if lookup(v, "instance", true) != false }
  load_balancer_arn = aws_lb.shared_int.arn
  port              = each.value.port
  protocol          = "TCP"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  # alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shared_int[each.key].arn
  }
}
