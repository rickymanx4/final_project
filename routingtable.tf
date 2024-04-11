###
# 1. Routing Table
###
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project_vpc.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Publinc-Route-Table"
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.project_vpc.id 
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}
###
# 2. Routing Table Association
### 
resource "aws_route_table_association" "public_subnet_asso" {
  count = length(var.public_subnet) 
  subnet_id      = element(aws_subnet.public[*].id, count.index) 
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "web_subnet_asso" {
  count = length(var.web_subnet) 
  subnet_id      = element(aws_subnet.web[*].id, count.index) 
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "app_subnet_asso" {
  count = length(var.app_subnet) 
  subnet_id      = element(aws_subnet.app[*].id, count.index) 
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "db_subnet_asso" {
  count = length(var.db_subnet) 
  subnet_id      = element(aws_subnet.db[*].id, count.index) 
  route_table_id = aws_route_table.private_rt.id
}