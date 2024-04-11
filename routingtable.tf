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