##############################################################################
################################ 1. Routing Table ############################
##############################################################################

################################ a. dmz_public ################################

resource "aws_route_table" "dmz_pub_rt" {
  count = 2
  vpc_id = local.dmz_vpc[count.index].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_internet[count.index].id
  }
  tags = {
    Name = "${local.dmz_vpc[count.index]}_pub_rt"
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
    Name = "${local.dmz_vpc[0]}_pri_rt_${local.az_ac[count.index]}"
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
    Name = "${local.dmz_vpc[1]}_pri_rt_${local.az_ac[count.index]}"
  }
}

# ################################ d. shared_zone ################################

resource "aws_route_table" "shared_pri_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[2].id
  tags = {
    Name = "${local.dmz_vpc[2]}_pri_rt_${count.index}"
  }
}

# ################################ d. product_zone ################################

resource "aws_route_table" "product_pri_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[3].id
  tags = {
    Name = "${local.dmz_vpc[3]}_pri_rt_${count.index}"
  }
}

# ################################ e. testdev_zone ################################

resource "aws_route_table" "testdev_pri_rt" {
  count = 2
  vpc_id = aws_vpc.project_vpc[4].id
  tags = {
    Name = "${local.dmz_vpc[4]}_pri_rt_${count.index}"
  }
}


# ##############################################################################
# ############################# 2. Routing Association #########################
# ##############################################################################

# ################################ a. user_dmz ################################
# resource "aws_route_table_association" "user_dmz_pub_rt_asso" {
#   for_each       = var.subnet_user_dmz_pub
#   subnet_id      = aws_subnet.user_dmz_pub_subnet[each.key].id
#   route_table_id = aws_route_table.user_dmz_pub_rt.id
# }

# resource "aws_route_table_association" "user_dmz_pri_rt_asso1" {  
#   subnet_id      = aws_subnet.user_dmz_pri_subnet["user_dmz_pri_01a"].id
#   route_table_id = aws_route_table.user_dmz_pri_rt_a.id
# }

# resource "aws_route_table_association" "user_dmz_pri_rt_asso2" {  
#   subnet_id      = aws_subnet.user_dmz_pri_subnet["user_dmz_pri_01c"].id
#   route_table_id = aws_route_table.user_dmz_pri_rt_c.id
# }

# ################################ b. dev_dmz ################################
# resource "aws_route_table_association" "dev_dmz_pub_rt_asso" {
#   for_each       = var.subnet_dev_dmz_pub
#   subnet_id      = aws_subnet.dev_dmz_pub_subnet[each.key].id
#   route_table_id = aws_route_table.dev_dmz_pub_rt.id
# }

# resource "aws_route_table_association" "dev_dmz_pri_rt_asso1" {
#   subnet_id      = aws_subnet.dev_dmz_pri_subnet["dev_dmz_pri_01a"].id
#   route_table_id = aws_route_table.dev_dmz_pri_rt_a.id
# }

# resource "aws_route_table_association" "dev_dmz_pri_rt_asso" {
#   subnet_id      = aws_subnet.dev_dmz_pri_subnet["dev_dmz_pri_01c"].id
#   route_table_id = aws_route_table.dev_dmz_pri_rt_c.id
# }

# ################################ c. shared_zone ################################
# resource "aws_route_table_association" "shared_pri_rt_asso1" {  
#   subnet_id      = aws_subnet.shared_subnet["shared_pri_01a"].id
#   route_table_id = aws_route_table.shared_pri_rt["shared_pri_01a"].id
# }

# resource "aws_route_table_association" "shared_pri_rt_asso2" {  
#   subnet_id      = aws_subnet.shared_subnet["shared_pri_01a"].id
#   route_table_id = aws_route_table.shared_pri_rt["shared_pri_01a"].id
# }

# ################################ d. product_zone ################################
# resource "aws_route_table_association" "product_rt_asso_01" {
#   for_each       = var.subnet_product_01
#   subnet_id      = aws_subnet.product_subnet_01[each.key].id
#   route_table_id = aws_route_table.product_pri_rt_01.id
# }

# resource "aws_route_table_association" "product_rt_asso_02" {
#   for_each       = var.subnet_product_02
#   subnet_id      = aws_subnet.product_subnet_02[each.key].id
#   route_table_id = aws_route_table.product_pri_rt_02.id
# }

# ################################ e. testdev_zone ################################
# resource "aws_route_table_association" "testdev_rt_asso_01" {
#   for_each       = var.subnet_testdev_01
#   subnet_id      = aws_subnet.testdev_subnet_01[each.key].id
#   route_table_id = aws_route_table.testdev_pri_rt_01.id
# }

# resource "aws_route_table_association" "testdev_rt_asso_02" {
#   for_each       = var.subnet_testdev_02
#   subnet_id      = aws_subnet.testdev_subnet_02[each.key].id
#   route_table_id = aws_route_table.testdev_pri_rt_02.id
# }