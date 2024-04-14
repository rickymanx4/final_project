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

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {  
  for_each            = var.tgw_vpc_attach    
  transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
  vpc_id              = aws_vpc.project_vpc[each.value.vpc_num].id
  subnet_ids          = [ [each.value.subnet1], [each.value.subnet2] ]

  tags = {
    Name = "${local.names[0]}_tgw_attache"
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]
}

# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_user_dmz" {  
#   transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
#   vpc_id              = aws_vpc.project_vpc[0].id
#   subnet_ids          = [aws_subnet.user_dmz_pub_subnet[0].id, aws_subnet.user_dmz_pub_subnet[2].id]

#   tags = {
#     Name = "${local.names[0]}_tgw_attache"
#   }
#   depends_on = [ aws_ec2_transit_gateway.tgw_main ]
# }

# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_dev_dmz" {  
#   transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
#   vpc_id              = aws_vpc.project_vpc[1].id
#   subnet_ids          = [aws_subnet.dev_dmz_pub_subnet[0].id, aws_subnet.dev_dmz_pub_subnet[2].id]

#   tags = {
#     Name = "${local.names[1]}_tgw_attache"
#   }
#   depends_on = [ aws_ec2_transit_gateway.tgw_main ]
# }

# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_shared" {  
#   transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
#   vpc_id              = aws_vpc.project_vpc[2].id
#   subnet_ids          = [aws_subnet.shared_pri_subnet[0].id]

#   tags = {
#     Name = "${local.names[2]}_tgw_attache"
#   }
#   depends_on = [ aws_ec2_transit_gateway.tgw_main ]
# }

# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_product" {  
#   transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
#   vpc_id              = aws_vpc.project_vpc[3].id
#   subnet_ids          = aws_subnet.product_pri_01_subnet[*].id

#   tags = {
#     Name = "${local.names[3]}_tgw_attache"
#   }
#   depends_on = [ aws_ec2_transit_gateway.tgw_main ]
# }

# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_testdev" {  
#   transit_gateway_id  = aws_ec2_transit_gateway.tgw_main.id
#   vpc_id              = aws_vpc.project_vpc[4].id
#   subnet_ids          = aws_subnet.testdev_pri_01_subnet[*].id

#   tags = {
#     Name = "${local.names[4]}_tgw_attache"
#   }
#   depends_on = [ aws_ec2_transit_gateway.tgw_main ]
# }




# resource "aws_ec2_transit_gateway_vpc_attachment" "shared" {
#   transit_gateway_id = aws_ec2_transit_gateway.main.id
#   vpc_id = aws_vpc.shared.id
#   subnet_ids = aws_subnet.shared_tgw[*].id

#   tags = {
#     Name = "shared_vpc_tgw_attach"
#   }
#   depends_on = [ aws_ec2_transit_gateway.main ]
# }
# resource "aws_ec2_transit_gateway_vpc_attachment" "test_dev" {
#   transit_gateway_id = aws_ec2_transit_gateway.main.id
#   vpc_id = aws_vpc.test_dev.id
#   subnet_ids = aws_subnet.test_dev_tgw[*].id

#   tags = {
#     Name = "test_dev_vpc_tgw_attach"
#   }
#   depends_on = [ aws_ec2_transit_gateway.main ]
# }
###
# 3. transit gateway routing table
###
# resource "aws_ec2_transit_gateway_route_table" "dev" {
#   transit_gateway_id = aws_ec2_transit_gateway.main.id
#   tags      = {
#     Name    = "dev-tgw-rt"
#   }
#   depends_on = [ aws_ec2_transit_gateway.main ]
# }
# resource "aws_ec2_transit_gateway_route_table" "shared" {
#   transit_gateway_id = aws_ec2_transit_gateway.main.id
#   tags      = {
#     Name    = "shared-tgw-rt"
#   }
#   depends_on = [ aws_ec2_transit_gateway.main ]
# }
# # resource "aws_ec2_transit_gateway_route_table" "prod" {
# #   transit_gateway_id = aws_ec2_transit_gateway.main.id
# #   tags      = {
# #     Name    = "prod-tgw-rt"
# #   }
# #   depends_on = [ aws_ec2_transit_gateway.main ]
# # }
# ###
# # 4. routing table associations
# # This is the link between a VPC (already symbolized with its attachment to the Transit Gateway)
# #  and the Route Table the VPC's packet will hit when they arrive into the Transit Gateway.
# # The Route Tables Associations do not represent the actual routes the packets are routed to.
# # These are defined in the Route Tables Propagations section below.
# ###
# resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-dev_dmz-assoc" {
#   transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.dev_dmz.id
#   transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.dev.id
# }
# resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-shared-assoc" {
#   transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.shared.id
#   transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.shared.id
# }
# resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-test_dev-assoc" {
#   transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.test_dev.id
#   transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.dev.id
# }
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