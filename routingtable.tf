###
# 1. Routing Table
###
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
  count = length(var.az_select)  
  vpc_id = aws_vpc.project_vpc["user_dmz_vpc"].id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "aws_nat_gateway.user_dmz_ngw_${count.index}.id"
  }
  tags = {
    Name = "user_dmz_pri_rt_${count.index}"
  }
}

resource "aws_route_table" "dev_dmz_pub_rts" {
  vpc_id = aws_vpc.project_vpc["dev_dmz_vpc"].id  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_dmz_igw.id
  }
  tags = {
    Name = "dev_dmz_pub_rt"
  }
}
resource "aws_route_table" "dev_dmz_pri_rt" {
  #for_each = var.dev_dmz_pri_rts
  vpc_id = aws_vpc.project_vpc["dev_dmz_vpc"].id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.dev_dmz_ngw_[*].id}"
  }
  tags = {
    Name = "${aws_nat_gateway.dev_dmz_ngw_[*].name}"
  }
}
###
# 2. Routing Table Association
### 
# resource "aws_route_table_association" "public_subnet_asso" {
#   count = length(var.public_subnet) 
#   subnet_id      = element(aws_subnet.public[*].id, count.index) 
#   route_table_id = aws_route_table.public_rt.id
# }
# resource "aws_route_table_association" "web_subnet_asso" {
#   count = length(var.web_subnet) 
#   subnet_id      = element(aws_subnet.web[*].id, count.index) 
#   route_table_id = aws_route_table.private_rt.id
# }
# resource "aws_route_table_association" "app_subnet_asso" {
#   count = length(var.app_subnet) 
#   subnet_id      = element(aws_subnet.app[*].id, count.index) 
#   route_table_id = aws_route_table.private_rt.id
# }
# resource "aws_route_table_association" "db_subnet_asso" {
#   count = length(var.db_subnet) 
#   subnet_id      = element(aws_subnet.db[*].id, count.index) 
#   route_table_id = aws_route_table.private_rt.id
# }