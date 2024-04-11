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


###
#2. Routing Table Association
### 
resource "aws_route_table_association" "user_dmz_pub_rt_asso" {
  #count = 4 
  subnet_id      = aws_subnet.user_dmz_subnet.*.id
  route_table_id = aws_route_table.user_dmz_pub_rt.id
}
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