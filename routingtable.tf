##############################################################################
################################ 1. Routing Table ############################
##############################################################################

################################ a. dev_dmz_public(nat_nwf, lb) ################################
resource "aws_route_table" "user_dmz_igw_rt" {
  vpc_id = local.user_dev_vpc[0]
  route {
    cidr_block = local.user_dmz_pub_subnet[2]
    network_interface_id = local.user_dmz_end[0]
  }
  route {
    cidr_block = local.user_dmz_pub_subnet[3]
    network_interface_id = local.user_dmz_end[1]
  }
  tags = {
    Name = "${local.names[0]}_igw_rt"
  }
}

resource "aws_route" "route_igw" {
  route_table_id            = aws_route_table.user_dmz_igw_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.gw_internet[0].id
}

resource "aws_route_table" "user_dmz_nat_nwf_rt" {
  count = 2
  vpc_id = local.user_dev_vpc[0]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_internet[0].id
  }
  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }
  tags = {
    Name = "${local.names[0]}_${local.userdev_pub_name[0]}_${local.userdev_pub_name[2]}_rt_${local.az_ac[count.index]}"
  }
}

resource "aws_route_table" "user_dmz_lb_rt" {
  count = 2
  vpc_id = local.user_dev_vpc[0]
  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = local.user_dmz_end[count.index]
  }
  # route {
  #   cidr_block = "10.0.0.0/8"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }
  tags = {
    Name = "${local.names[0]}_${local.userdev_pub_name[4]}_rt_${local.az_ac[count.index]}"
  }
}

################################ b. user_dmz_proxy ################################

resource "aws_route_table" "user_dmz_proxy_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[0].id
  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = local.user_dmz_end[count.index]
  }
  # route {
  #   cidr_block = "10.0.0.0/8"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }  

  tags = {
    Name = "${local.names[0]}_${local.userdev_pri_name[0]}_rt_${local.az_ac[count.index]}"
  }  
}

################################ c. user_dmz_pri_tgw ################################

resource "aws_route_table" "user_dmz_tgw_rt" {
  count  = 2
  vpc_id = aws_vpc.project_vpc[0].id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw_user_nat[count.index].id
  }

  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }  
  tags = {
    Name = "${local.names[0]}_${local.userdev_pri_name[2]}_rt_${local.az_ac[count.index]}"
  }
}


################################ a. dev_dmz_public(nat_nwf, lb) ################################

resource "aws_route_table" "dev_dmz_nat_nwf_rt" {
  count = 2
  vpc_id = local.user_dev_vpc[1]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_internet[1].id
  }
  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }
  tags = {
    Name = "${local.names[1]}_${local.userdev_pub_name[0]}_${local.userdev_pub_name[2]}_rt_${local.az_ac[count.index]}"
  }
}

resource "aws_route_table" "dev_dmz_lb_rt" {
  count = 2
  vpc_id = local.user_dev_vpc[1]
  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = local.dev_dmz_end[count.index]
  }
  # route {
  #   cidr_block = "10.0.0.0/8"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }
  tags = {
    Name = "${local.names[1]}_${local.userdev_pub_name[4]}_rt_${local.az_ac[count.index]}"
  }
}

################################ b. dev_dmz_proxy ################################

resource "aws_route_table" "dev_dmz_proxy_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[1].id
  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = local.dev_dmz_end[count.index]
  }
  # route {
  #   cidr_block = "10.0.0.0/8"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }  
  tags = {
    Name = "${local.names[1]}_${local.userdev_pri_name[0]}_rt_${local.az_ac[count.index]}"
  }
}

################################ c. dev_dmz_pri_tgw ################################

resource "aws_route_table" "dev_dmz_tgw_rt" {
  count  = 2
  vpc_id = aws_vpc.project_vpc[1].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw_user_nat[count.index].id
  }

  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }  
  tags = {
    Name = "${local.names[1]}_${local.userdev_pri_name[2]}_rt_${local.az_ac[count.index]}"
  }
}



# ################################ d. shared_zone ################################

resource "aws_route_table" "shared_nexus_rt" {
  vpc_id = aws_vpc.project_vpc[2].id
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }    
  tags = {
    Name = "${local.names[2]}_pri_rt_${local.shared_name[0]}"
  }
}

resource "aws_route_table" "shared_control_rt" {
  vpc_id = aws_vpc.project_vpc[2].id
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }  
  tags = {
    Name = "${local.names[2]}_pri_rt_${local.shared_name[1]}"
  }
}

# ################################ d. prodtest_node_rt ################################

resource "aws_route_table" "prodtest_node_rt" {
  count = 2
  vpc_id = local.prod_test_vpc[count.index]
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }   
  tags = {
    Name = "${local.names[count.index + 3]}_pri_rt_${local.prodtest_name[0]}"
  }
}

# ################################ e. prodtest_rds_rt ################################

resource "aws_route_table" "prodtest_rds_rt" {
  count = 2
  vpc_id = local.prod_test_vpc[count.index]
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }  
  tags = {
    Name = "${local.names[count.index + 3]}_pri_rt_${local.prodtest_name[2]}"
  }
}

# ################################ e. prodtest_tgw_rt ################################

resource "aws_route_table" "prodtest_tgw_rt" {
  count = 2
  vpc_id = local.prod_test_vpc[count.index]
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  }  
  tags = {
    Name = "${local.names[count.index + 3]}_pri_rt_${local.prodtest_name[4]}"
  }
}


# ##############################################################################
# ############################# 2. Routing Association #########################
# ##############################################################################

################################ a. user_dmz ################################

resource "aws_route_table_association" "user_dmz_nat_nwf_rt_a_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_user_dmz_pub[count.index * 2].id
  route_table_id = aws_route_table.user_dmz_nat_nwf_rt[0].id
}

resource "aws_route_table_association" "user_dmz_nat_nwf_rt_c_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_user_dmz_pub[count.index * 2 + 1].id
  route_table_id = aws_route_table.user_dmz_nat_nwf_rt[1].id
}

resource "aws_route_table_association" "user_dmz_lb_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_user_dmz_pub[count.index + 4].id
  route_table_id = aws_route_table.user_dmz_lb_rt[count.index].id
}

resource "aws_route_table_association" "user_dmz_proxy_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_user_dmz_pri[count.index].id
  route_table_id = aws_route_table.user_dmz_proxy_rt[count.index].id
}

resource "aws_route_table_association" "user_dmz_tgw_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_user_dmz_pri[count.index + 2].id
  route_table_id = aws_route_table.user_dmz_tgw_rt[count.index].id
}

# # ################################ b. dev_dmz ################################

resource "aws_route_table_association" "dev_dmz_nat_nwf_rt_a_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_dev_dmz_pub[count.index * 2].id
  route_table_id = aws_route_table.dev_dmz_nat_nwf_rt[0].id
}

resource "aws_route_table_association" "dev_dmz_nat_nwf_rt_c_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_dev_dmz_pub[count.index * 2 + 1].id
  route_table_id = aws_route_table.dev_dmz_nat_nwf_rt[1].id
}

resource "aws_route_table_association" "dev_dmz_lb_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_dev_dmz_pub[count.index + 4].id
  route_table_id = aws_route_table.dev_dmz_lb_rt[count.index].id
}

resource "aws_route_table_association" "dev_dmz_proxy_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_dev_dmz_pri[count.index].id
  route_table_id = aws_route_table.dev_dmz_proxy_rt[count.index].id
}

resource "aws_route_table_association" "dev_dmz_tgw_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_dev_dmz_pri[count.index + 2].id
  route_table_id = aws_route_table.dev_dmz_tgw_rt[count.index].id
}

# # ################################ c. shared_zone ################################

resource "aws_route_table_association" "shared_nex_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_shared_pri_01[count.index].id
  route_table_id = aws_route_table.shared_nexus_rt.id
}

resource "aws_route_table_association" "shared_src_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_shared_pri_02[count.index].id
  route_table_id = aws_route_table.shared_control_rt.id
}

# # ################################ d. product_zone ################################

resource "aws_route_table_association" "product_node_rt_asso" {
  count          = 2 
  subnet_id      = aws_subnet.subnet_product_pri[count.index].id
  route_table_id = aws_route_table.prodtest_node_rt[0].id
}

resource "aws_route_table_association" "product_rds_rt_asso" {
  count          = 2 
  subnet_id      = aws_subnet.subnet_product_pri[count.index + 2].id
  route_table_id = aws_route_table.prodtest_rds_rt[0].id
}

resource "aws_route_table_association" "product_tgw_rt_asso" {
  count          = 2 
  subnet_id      = aws_subnet.subnet_product_pri[count.index + 4].id
  route_table_id = aws_route_table.prodtest_tgw_rt[0].id
}

# # ################################ e. testdev_zone ################################

resource "aws_route_table_association" "testdev_node_rt_asso" {
  count          = 2 
  subnet_id      = aws_subnet.subnet_testdev_pri[count.index].id
  route_table_id = aws_route_table.prodtest_node_rt[1].id
}

resource "aws_route_table_association" "testdev_rds_rt_asso" {
  count          = 2 
  subnet_id      = aws_subnet.subnet_testdev_pri[count.index + 2].id
  route_table_id = aws_route_table.prodtest_rds_rt[1].id
}

resource "aws_route_table_association" "testdev_tgw_rt_asso" {
  count          = 2 
  subnet_id      = aws_subnet.subnet_testdev_pri[count.index + 4].id
  route_table_id = aws_route_table.prodtest_tgw_rt[1].id
}

