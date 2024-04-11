###
# 1. Elastic IP
###
resource "aws_eip" "project_nat_eip" {
  vpc = true

  lifecycle {
    create_before_destroy = true
  }
}
###
#2. Internet & NAT Gateways
###
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project_vpc.id 
  
  tags = {
    Name = "projectVPC-IGW"
 }
}
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.project_nat_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "projectVPC-NGW"
 }
 depends_on = [aws_internet_gateway.igw]
}