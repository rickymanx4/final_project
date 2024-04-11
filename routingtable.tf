##############################################################################
################################ 1. Routing Table ############################
##############################################################################

################################ a. user_dmz ################################
resource "aws_route_table" "user_dmz_pub_rt" {
  vpc_id = aws_vpc.project_vpc["user_dmz_vpc"].id  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.user_dmz_igw.id
  }
  tags = {
    Name = "user_dmz_pub_rt"
  }
}
resource "aws_route_table" "user_dmz_pri_rt_a" {
  vpc_id = aws_vpc.project_vpc["user_dmz_vpc"].id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.user_dmz_ngw_a.id
  }
  tags = {
    Name = "user_dmz_pri_rt_a"
  }
}
resource "aws_route_table" "user_dmz_pri_rt_c" {
  vpc_id = aws_vpc.project_vpc["user_dmz_vpc"].id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.user_dmz_ngw_c.id
  }
  tags = {
    Name = "user_dmz_pri_rt_c"
  }
}

################################ b. dev_dmz ################################
resource "aws_route_table" "dev_dmz_pub_rt" {
  vpc_id = aws_vpc.project_vpc["dev_dmz_vpc"].id  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_dmz_igw.id
  }
  tags = {
    Name = "dev_dmz_pub_rt"
  }
}
resource "aws_route_table" "dev_dmz_pri_rt_a" {   
  vpc_id = aws_vpc.project_vpc["dev_dmz_vpc"].id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev_dmz_ngw_a.id
  }
  tags = {
    Name = "dev_dmz_pri_rt_a"
  }
}

resource "aws_route_table" "dev_dmz_pri_rt_c" {   
  vpc_id = aws_vpc.project_vpc["dev_dmz_vpc"].id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev_dmz_ngw_c.id
  }
  tags = {
    Name = "dev_dmz_pri_rt_c"
  }
}

################################ c. shared_zone ################################
resource "aws_route_table" "shared_pri_rt" {
  for_each = length(var.subnet_shared)
  vpc_id = aws_vpc.project_vpc["shared_vpc"].id  
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.dev_dmz_igw.id
  # }
  tags = {
    Name = var.subnet_shared[each.key]
  }
}

################################ d. product_zone ################################
resource "aws_route_table" "product_pri_rt_a" {
  for_each = length(var.subnet_product_a) 
  vpc_id = aws_vpc.project_vpc["product_vpc"].id  
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.dev_dmz_igw.id
  # }
  tags = {
    Name = var.subnet_product_a[each.key]
  }
}

resource "aws_route_table" "product_pri_rt_c" {
  for_each = length(var.subnet_product_c) 
  vpc_id = aws_vpc.project_vpc["product_vpc"].id  
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.dev_dmz_igw.id
  # }
  tags = {
    Name = var.subnet_product_c[each.key]
  }
}

################################ e. testdev_zone ################################
resource "aws_route_table" "testdev_pri_rt_a" {
  for_each = length(var.subnet_testdev_a)
  vpc_id = aws_vpc.project_vpc["testdev_vpc"].id  
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.dev_dmz_igw.id
  # }
  tags = {
    Name = var.subnet_testdev_a[each.key]
  }
}

resource "aws_route_table" "testdev_pri_rt_c" {
  for_each = length(var.subnet_testdev_c)
  vpc_id = aws_vpc.project_vpc["testdev_vpc"].id  
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.dev_dmz_igw.id
  # }
  tags = {
    Name = var.subnet_testdev_c[each.key]
  }
}

##############################################################################
############################# 2. Routing Association #########################
##############################################################################

################################ a. user_dmz ################################
resource "aws_route_table_association" "user_dmz_pub_rt_asso" {
  for_each       = var.subnet_user_dmz_pub
  subnet_id      = aws_subnet.user_dmz_pub_subnet[each.key].id
  route_table_id = aws_route_table.user_dmz_pub_rt.id
}

resource "aws_route_table_association" "user_dmz_pri_rt_asso1" {  
  subnet_id      = aws_subnet.user_dmz_pri_subnet["user_dmz_pri_01a"].id
  route_table_id = aws_route_table.user_dmz_pri_rt_a.id
}

resource "aws_route_table_association" "user_dmz_pri_rt_asso2" {  
  subnet_id      = aws_subnet.user_dmz_pri_subnet["user_dmz_pri_01c"].id
  route_table_id = aws_route_table.user_dmz_pri_rt_c.id
}

################################ b. dev_dmz ################################
resource "aws_route_table_association" "dev_dmz_pub_rt_asso" {
  for_each       = var.subnet_dev_dmz_pub
  subnet_id      = aws_subnet.dev_dmz_pub_subnet[each.key].id
  route_table_id = aws_route_table.dev_dmz_pub_rt.id
}

resource "aws_route_table_association" "dev_dmz_pri_rt_asso1" {
  subnet_id      = aws_subnet.dev_dmz_pri_subnet["dev_dmz_pri_01a"].id
  route_table_id = aws_route_table.dev_dmz_pri_rt_a.id
}

resource "aws_route_table_association" "dev_dmz_pri_rt_asso" {
  subnet_id      = aws_subnet.dev_dmz_pri_subnet["dev_dmz_pri_01c"].id
  route_table_id = aws_route_table.dev_dmz_pri_rt_c.id
}

################################ c. shared_zone ################################
resource "aws_route_table_association" "shared_pri_rt_asso1" {  
  subnet_id      = aws_subnet.shared_subnet["shared_pri_01a"].id
  route_table_id = aws_route_table.shared_rt["shared_pri_01a"].id
}

resource "aws_route_table_association" "user_dmz_pri_rt_asso2" {  
  subnet_id      = aws_subnet.shared_subnet["shared_pri_01a"].id
  route_table_id = aws_route_table.shared_rt["shared_pri_01a"].id
}

################################ d. product_zone ################################
resource "aws_route_table_association" "product_rt_asso_a" {
  for_each       = var.subnet_product_a
  subnet_id      = aws_subnet.product_subnet_a[each.key].id
  route_table_id = aws_route_table.product_pri_rt_a.id
}

resource "aws_route_table_association" "product_rt_asso_c" {
  for_each       = var.subnet_product_c
  subnet_id      = aws_subnet.product_subnet_c[each.key].id
  route_table_id = aws_route_table.product_pri_rt_c.id
}

################################ e. testdev_zone ################################
resource "aws_route_table_association" "testdev_rt_asso_a" {
  for_each       = var.subnet_testdev_a
  subnet_id      = aws_subnet.testdev_subnet_a[each.key].id
  route_table_id = aws_route_table.testdev_pri_rt_a.id
}

resource "aws_route_table_association" "testdev_rt_asso_c" {
  for_each       = var.subnet_testdev_c
  subnet_id      = aws_subnet.testdev_subnet_c[each.key].id
  route_table_id = aws_route_table.testdev_pri_rt_c.id
}