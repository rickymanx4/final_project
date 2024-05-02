##############################################################################
############################# 1. transit_gateway #############################
##############################################################################

resource "aws_ec2_transit_gateway" "tgw_main" {
  description                     = "connect various vpcs"

  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = local.tgw_name
  }
}

##############################################################################
########################### 2. VPC attach to tgw #############################
##############################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "user_dmz" {  
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[0].id
  subnet_ids          = [aws_subnet.subnet_user_dmz_pri[2].id, aws_subnet.subnet_user_dmz_pri[3].id]

  tags = {
    Name = "${local.names[0]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "dev_dmz" { 
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[1].id
  subnet_ids          = [aws_subnet.subnet_dev_dmz_pri[2].id, aws_subnet.subnet_dev_dmz_pri[3].id]

  tags = {
    Name = "${local.names[1]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "shared" {  
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[2].id
  subnet_ids          = aws_subnet.subnet_shared_pri_01[*].id
  tags = {
    Name = "${local.names[2]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "product" {  
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[3].id
  subnet_ids          = [aws_subnet.subnet_product_pri[2].id, aws_subnet.subnet_product_pri[3].id]

  tags = {
    Name = "${local.names[3]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "testdev" {  
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[4].id
  subnet_ids          = [aws_subnet.subnet_testdev_pri[2].id, aws_subnet.subnet_testdev_pri[3].id]

  tags = {
    Name = "${local.names[4]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}

##############################################################################
####################### 3. Create to tgw route table #########################
##############################################################################

resource "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  count              = 3
  transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  tags               = {
    Name             = "${local.names[count.index]}-tgw-rt"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}


##############################################################################
##################### 4. tgw route table to vpc association###################
##############################################################################

resource "aws_ec2_transit_gateway_route_table_association" "user-user-assoc" {
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.user_dmz.id
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.tgw_rt[0].id
}

resource "aws_ec2_transit_gateway_route_table_association" "user-product-assoc" {
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.product.id
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.tgw_rt[0].id
}

resource "aws_ec2_transit_gateway_route_table_association" "dev-dev-assoc" {
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.dev_dmz.id
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.tgw_rt[1].id
}

resource "aws_ec2_transit_gateway_route_table_association" "dev-testdev-assoc" {
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.testdev.id
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.tgw_rt[1].id
 }

resource "aws_ec2_transit_gateway_route_table_association" "shared-shared-assoc" {
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.shared.id
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.tgw_rt[2].id
}


##############################################################################
###################### 5. tgw route_table propagation ########################
##############################################################################

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-user-to-user" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.user_dmz.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[0].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-user-to-shared" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[0].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-user-to-product" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.product.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[0].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-dev" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev_dmz.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[1].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-shared" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[1].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-testdev" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.testdev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[1].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-shared-to-user_dev_vpc" {
  count                          = 2
  transit_gateway_attachment_id  = local.user_dev_tgw_rt[count.index].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[2].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-shared-to-prod_test_vpc" {
  count                          = 2
  transit_gateway_attachment_id  = local.prod_test_tgw_rt[count.index].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[2].id
}


##############################################################################
##################### 6. tgw route_table to internet #########################
##############################################################################
resource "aws_ec2_transit_gateway_route" "user" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.user_dmz.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[0].id
}

resource "aws_ec2_transit_gateway_route" "dev" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev_dmz.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[1].id
}

resource "aws_ec2_transit_gateway_route" "shared" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev_dmz.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt[2].id
}
