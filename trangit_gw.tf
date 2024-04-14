###
# 1. create transit gateway
###
resource "aws_ec2_transit_gateway" "tgw_main" {
  description                     = "connect various vpcs"

  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = local.tgw_name
  }
}

###
# 2. transit gateway attachment
###

# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {  
#   for_each            = var.tgw_vpc_attach    
#   transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
#   vpc_id              = each.value.vpc
#   subnet_ids          = [each.value.subnet1, each.value.subnet2]

#   tags = {
#     Name = each.value.name
#   }
#   depends_on = [ aws_ec2_transit_gateway.tgw_main ]
# }

resource "aws_ec2_transit_gateway_vpc_attachment" "user_dmz" {  
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[0].id
  subnet_ids          = [aws_subnet.subnet_user_dmz_pub[0].id, aws_subnet.subnet_user_dmz_pub[2].id]

  tags = {
    Name = "${local.names[0]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "dev_dmz" {  
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[1].id
  subnet_ids          = [aws_subnet.subnet_dev_dmz_pub[0].id, aws_subnet.subnet_dev_dmz_pub[2].id]

  tags = {
    Name = "${local.names[1]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "shared" {  
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[2].id
  subnet_ids          = [aws_subnet.subnet_shared_pri[0].id]

  tags = {
    Name = "${local.names[2]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "product" {  
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[3].id
  subnet_ids          = aws_subnet.subnet_product_pri_01[*].id

  tags = {
    Name = "${local.names[3]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "testdev" {  
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[4].id
  subnet_ids          = aws_subnet.subnet_testdev_pri_01[*].id

  tags = {
    Name = "${local.names[4]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}


###
# 3. transit gateway routing table
###
resource "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  count              = 5
  transit_gateway_id = aws_ec2_transit_gateway.tgw_main.id
  tags               = {
    Name             = "${local.names[count.index]}-tgw-rt"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}


# ###
# # 4. routing table associations
# # This is the link between a VPC (already symbolized with its attachment to the Transit Gateway)
# #  and the Route Table the VPC's packet will hit when they arrive into the Transit Gateway.
# # The Route Tables Associations do not represent the actual routes the packets are routed to.
# # These are defined in the Route Tables Propagations section below.
# ###
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-user_dmz-assoc" {
  count                           = 5
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.user_dmz.id
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.tgw_rt[0].id
}
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-dev_dmz-assoc" {
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.dev_dmz.id
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.tgw_rt[1].id
}
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-shared-assoc" {
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.shared.id
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.tgw_rt[3].id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-product-assoc" {
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.product.id
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.tgw_rt[3].id
}  
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-testdev-assoc" {
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.testdev.id
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.tgw_rt[4].id
}
# ###
# # 5. routing table propagations
# # This section defines which VPCs will be routed from each Route Table created in the Transit Gateway
# ###
# resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-shared_vpc" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.shared.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev.id
# }
# resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-test_dev_vpc" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.test_dev.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev.id
# }
# resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-shared-to-dev_dmz_vpc" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev_dmz.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.shared.id
# }
# resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-shared-to-test_dev_vpc" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.test_dev.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.shared.id
# }
# ###
# # 6. transit gateway static route
# ###
# resource "aws_ec2_transit_gateway_route" "dev" {
#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev_dmz.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev.id
# }
# resource "aws_ec2_transit_gateway_route" "shared" {
#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev_dmz.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.shared.id
# }
# # resource "aws_ec2_transit_gateway_route" "prod" {
# #   destination_cidr_block         = "0.0.0.0/0"
# #   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example.id
# #   transit_gateway_route_table_id = aws_ec2_transit_gateway.example.association_default_route_table_id
# # }