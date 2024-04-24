##############################################################################
################################ 1. Routing Table ############################
##############################################################################

################################ a. dmz_public ################################

resource "aws_route_table" "dmz_nat_tgw_rt" {
  count = 2
  vpc_id = local.user_dev_vpc[count.index]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_internet[count.index].id
  }
  # route {
  #   cidr_block = "10.0.0.0/8"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }
  tags = {
    Name = "${local.names[count.index]}_${local.userdev_rt_name[0]}_${local.userdev_rt_name[2]}_pub_rt"
  }
}

resource "aws_route_table" "dmz_lb_rt" {
  count = 2
  vpc_id = local.user_dev_vpc[count.index]
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.gw_internet[count.index].id
  # }
  # route {
  #   cidr_block = "10.0.0.0/8"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }
  tags = {
    Name = "${local.names[count.index]}_${local.userdev_rt_name[4]}_pub_rt"
  }
}

# resource "aws_route_table" "dmz_tgw_rt" {
#   count = 2
#   vpc_id = local.user_dev_vpc[count.index]
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw_internet[count.index].id
#   }
#   route {
#     cidr_block = "10.0.0.0/8"
#     transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
#   }
#   tags = {
#     Name = "${local.names[count.index]}_${local.userdev_rt_name[4]}_pub_rt"
#   }
# }

################################ b. user_dmz_pri ################################

resource "aws_route_table" "user_dmz_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw_user_nat[count.index].id
  }

  # route {
  #   cidr_block = "10.0.0.0/8"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }  
  tags = {
    Name = "${local.names[0]}_pri_rt_${local.userdev_rt_name[6]}_${local.az_ac[count.index]}"
  }
}

################################ c. dev_dmz_pri ################################

resource "aws_route_table" "dev_dmz_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[1].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw_dev_nat[count.index].id
  }
  # route {
  #   cidr_block = "10.0.0.0/8"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }  
  tags = {
    Name = "${local.names[1]}_pri_rt_${local.userdev_rt_name[6]}_${local.az_ac[count.index]}"
  }
}

# ################################ d. shared_zone ################################

resource "aws_route_table" "shared_nexus_rt" {
  vpc_id = aws_vpc.project_vpc[2].id
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }    
  tags = {
    Name = "${local.names[2]}_pri_rt_${local.shared_rt_name[0]}"
  }
}

resource "aws_route_table" "shared_control_rt" {
  vpc_id = aws_vpc.project_vpc[2].id
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }  
  tags = {
    Name = "${local.names[2]}_pri_rt_${local.shared_rt_name[1]}"
  }
}

# ################################ d. prodtest_node_rt ################################

resource "aws_route_table" "prodtest_node_rt" {
  count = 2
  vpc_id = local.prod_test_vpc[count.index]
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }   
  tags = {
    Name = "${local.names[count.index + 3]}_pri_rt_${local.prodtest_rt_name[0]}"
  }
}

# ################################ e. prodtest_rds_rt ################################

resource "aws_route_table" "prodtest_rds_rt" {
  count = 2
  vpc_id = local.prod_test_vpc[count.index]
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }  
  tags = {
    Name = "${local.names[count.index + 3]}_pri_rt_${local.prodtest_rt_name[2]}"
  }
}

# ################################ e. prodtest_tgw_rt ################################

resource "aws_route_table" "prodtest_tgw_rt" {
  count = 2
  vpc_id = local.prod_test_vpc[count.index]
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  # }  
  tags = {
    Name = "${local.names[count.index + 3]}_pri_rt_${local.prodtest_rt_name[4]}"
  }
}


# ##############################################################################
# ############################# 2. Routing Association #########################
# ##############################################################################

# ################################ a. user_dmz ################################

resource "aws_route_table_association" "user_dmz_nat_tgw_rt_asso" {
  count          = 4
  subnet_id      = aws_subnet.subnet_user_dmz_pub[count.index].id
  route_table_id = aws_route_table.dmz_nat_tgw_rt[0].id
}

resource "aws_route_table_association" "user_dmz_lb_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_user_dmz_pub[count.index + 4].id
  route_table_id = aws_route_table.dmz_lb_rt[0].id
}

resource "aws_route_table_association" "user_dmz_pri_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_user_dmz_pri[count.index].id
  route_table_id = aws_route_table.user_dmz_rt[count.index].id
}

# # ################################ b. dev_dmz ################################

resource "aws_route_table_association" "dev_dmz_nat_tgw_rt_asso" {
  count          = 4
  subnet_id      = aws_subnet.subnet_dev_dmz_pub[count.index].id
  route_table_id = aws_route_table.dmz_nat_tgw_rt[1].id
}

resource "aws_route_table_association" "dev_dmz_lb_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_dev_dmz_pub[count.index + 4].id
  route_table_id = aws_route_table.dmz_lb_rt[1].id
}

resource "aws_route_table_association" "dev_dmz_pri_rt_asso" {
  count          = 2
  subnet_id      = aws_subnet.subnet_dev_dmz_pri[count.index].id
  route_table_id = aws_route_table.dev_dmz_rt[count.index].id
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

