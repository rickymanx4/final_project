###
# 1. Elastic IP
###
resource "aws_eip" "dmz_eip" {
  #domain = "vpc"
  count =  var.eip_count
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "dmz_eip_${count.index + 1}"
  }
}
###
#2. Internet & NAT Gateways
###
resource "aws_internet_gateway" "user_dmz_igw" {
  vpc_id = aws_vpc.project_vpc["user_dmz_vpc"].id   
  tags = {
    Name = "user_dmz_vpc_IGW"
 }
}

resource "aws_internet_gateway" "dev_dmz_igw" {
  vpc_id = aws_vpc.project_vpc["dev_dmz_vpc"].id   
  tags = {
    Name = "dev_dmz_vpc_IGW"
 }
}

resource "aws_nat_gateway" "user_dmz_ngw_a" {
  allocation_id = aws_eip.dmz_eip[0].id
  subnet_id     = aws_subnet.user_dmz_subnet["user_dmz_pub_01a"].id
  tags = {
    Name = "user_dmz_nat_a"
 }
 depends_on = [aws_internet_gateway.user_dmz_igw]
}

resource "aws_nat_gateway" "user_dmz_ngw_c" {
  allocation_id = aws_eip.dmz_eip[1].id
  subnet_id     = aws_subnet.user_dmz_subnet["user_dmz_pub_01c"].id
  tags = {
    Name = "user_dmz_nat_c"
 }
 depends_on = [aws_internet_gateway.user_dmz_igw]
}

resource "aws_nat_gateway" "dev_dmz_ngw_a" {
  allocation_id = aws_eip.dmz_eip[2].id
  subnet_id     = aws_subnet.dev_dmz_subnet["dev_dmz_pub_01a"].id
  tags = {
    Name = "dev_dmz_nat_a"
 }
 depends_on = [aws_internet_gateway.dev_dmz_igw]
}

resource "aws_nat_gateway" "dev_dmz_ngw_c" {
  allocation_id = aws_eip.dmz_eip[3].id
  subnet_id     = aws_subnet.dev_dmz_subnet["dev_dmz_pub_01c"].id
  tags = {
    Name = "dev_dmz_nat_c"
 }
 depends_on = [aws_internet_gateway.dev_dmz_igw]
}