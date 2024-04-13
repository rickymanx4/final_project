##############################################################################
################################## 1. Elastic IP##############################
##############################################################################
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

##############################################################################
#########################2. Internet Gateways#################################
##############################################################################

resource "aws_internet_gateway" "dmz_igw" {
  count = 2
  vpc_id = local.dmz_vpc[count.index]
  
  tags = {
    Name = element(var.name, count.index)
 }
}

##############################################################################
############################3. Nat Gateways###################################
##############################################################################

################################ a. user_dmz ################################

# resource "aws_nat_gateway" "user_dmz_ngw_a" {
#   allocation_id = aws_eip.dmz_eip[0].id
#   subnet_id     = aws_subnet.user_dmz_pub_subnet[0].id 10
#   tags = {
#     Name = "user_dmz_ngw_${local.az_ac[0]}"
#  }
#  depends_on = [aws_internet_gateway.dmz_igw]
# }

# resource "aws_nat_gateway" "user_dmz_ngw_c" {
#   allocation_id = aws_eip.dmz_eip[1].id
#   subnet_id     = aws_subnet.user_dmz_pub_subnet[2].id 110
#   tags = {
#     Name = "user_dmz_ngw_${local.az_ac[1]}"
#  }
#  depends_on = [aws_internet_gateway.dmz_igw]
# }

resource "aws_nat_gateway" "dmz_ngw" {
  count = 2
  allocation_id = local.user_eip[count.index]
  subnet_id     = local.user_sub[count.index]
  tags = {
    Name = "${local.names[count.index]}_ngw_${local.az_ac[count.index]}"
 }
 depends_on = [aws_internet_gateway.dmz_igw]
}

# ################################ b. dev_dmz ################################

# resource "aws_nat_gateway" "dev_dmz_ngw_a" {
#   allocation_id = aws_eip.dmz_eip[2].id
#   subnet_id     = aws_subnet.dev_dmz_pub_subnet[0].id
#   tags = {
#     Name = "dev_dmz_ngw_${local.az_ac[0]}"
#  }
#  depends_on = [aws_internet_gateway.dmz_igw]
# }

# resource "aws_nat_gateway" "dev_dmz_ngw_c" {
#   allocation_id = aws_eip.dmz_eip[3].id
#   subnet_id     = aws_subnet.dev_dmz_pub_subnet[2].id
#   tags = {
#     Name = "dev_dmz_ngw_${local.az_ac[1]}"
#  }
#  depends_on = [aws_internet_gateway.dmz_igw]
# }
