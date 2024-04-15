##############################################################################
################################ 1. Routing Table ############################
##############################################################################

################################ a. dmz_public ################################

resource "aws_route_table" "dmz_pub_rt" {
  count = 2
  vpc_id = local.user_dev_vpc[count.index]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_internet[count.index].id
  }
  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }
  tags = {
    Name = "${local.names[count.index]}_pub_rt"
  }
}

################################ b. user_dmz ################################

resource "aws_route_table" "user_dmz_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw_user_nat[count.index].id
  }
  tags = {
    Name = "${local.names[0]}_pri_rt_${local.az_ac[count.index]}"
  }
}

################################ c. dev_dmz ################################

resource "aws_route_table" "dev_dmz_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[1].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw_dev_nat[count.index].id
  }
  tags = {
    Name = "${local.names[1]}_pri_rt_${local.az_ac[count.index]}"
  }
}

# ################################ d. shared_zone ################################

resource "aws_route_table" "shared_pri_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[2].id
  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }  
  tags = {
    Name = "${local.names[2]}_pri_rt_${count.index}"
  }
}

# ################################ d. product_zone ################################

resource "aws_route_table" "product_pri_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[3].id
  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }  
  tags = {
    Name = "${local.names[3]}_pri_rt_${count.index}"
  }
}

# ################################ e. testdev_zone ################################

resource "aws_route_table" "testdev_pri_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[4].id
  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }  
  tags = {
    Name = "${local.names[4]}_pri_rt_${count.index}"
  }
}


# ##############################################################################
# ############################# 2. Routing Association #########################
# ##############################################################################

# ################################ a. user_dmz ################################

resource "aws_route_table_association" "user_dmz_pub_rt_asso" {
  count = length(local.user_dmz_pub_subnet)
  subnet_id      = aws_subnet.subnet_user_dmz_pub[count.index].id
  route_table_id = aws_route_table.dmz_pub_rt[0].id
}

resource "aws_route_table_association" "user_dmz_pri_rt_asso" {
  count = 2
  subnet_id      = aws_subnet.subnet_user_dmz_pri[count.index].id
  route_table_id = aws_route_table.user_dmz_rt[count.index].id
}

# ################################ b. dev_dmz ################################

resource "aws_route_table_association" "dev_dmz_pub_rt_asso" {
  count = length(local.dev_dmz_pub_subnet)
  subnet_id      = aws_subnet.subnet_dev_dmz_pub[count.index].id
  route_table_id = aws_route_table.dmz_pub_rt[1].id
}

resource "aws_route_table_association" "dev_dmz_pri_rt_asso" {
  count = 2
  subnet_id      = aws_subnet.subnet_dev_dmz_pri[count.index].id
  route_table_id = aws_route_table.dev_dmz_rt[count.index].id
}

# ################################ c. shared_zone ################################

resource "aws_route_table_association" "shared_nex_rt_asso" {
  count = 2
  subnet_id      = aws_subnet.subnet_shared_pri_01[count.index]
  route_table_id = aws_route_table.shared_pri_rt[0].id
}

resource "aws_route_table_association" "shared_src_rt_asso" {
  count = 2
  subnet_id      = aws_subnet.subnet_shared_pri_02[count.index]
  route_table_id = aws_route_table.shared_pri_rt[1].id
}

# ################################ d. product_zone ################################

resource "aws_route_table_association" "product_pri_rt_asso_01" {
  count = 2
  subnet_id      = aws_subnet.subnet_product_pri_01[count.index].id
  route_table_id = aws_route_table.product_pri_rt[0].id
}

resource "aws_route_table_association" "product_pri_rt_asso_02" {
  count = 2
  subnet_id      = aws_subnet.subnet_product_pri_02[count.index].id
  route_table_id = aws_route_table.product_pri_rt[1].id
}

# ################################ e. testdev_zone ################################

resource "aws_route_table_association" "testdev_pri_rt_asso_01" {
  count = 2
  subnet_id      = aws_subnet.subnet_testdev_pri_01[count.index].id
  route_table_id = aws_route_table.testdev_pri_rt[0].id
}

resource "aws_route_table_association" "testdev_pri_rt_asso_02" {
  count = 2
  subnet_id      = aws_subnet.subnet_testdev_pri_02[count.index].id
  route_table_id = aws_route_table.testdev_pri_rt[1].id
}
