##############################################################################
################################## 1. Elastic IP##############################
##############################################################################
resource "aws_eip" "dmz_eip" {
  #domain = "vpc"
  count =  2
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

resource "aws_internet_gateway" "gw_internet" {
  count = 2
  vpc_id = local.user_dev_vpc[count.index]
  
  tags = {
    Name = element(var.name, count.index)
 }
}

##############################################################################
############################3. Nat Gateways###################################
##############################################################################

################################ a. user_dmz ################################

resource "aws_nat_gateway" "gw_user_nat" {
  count         = length(aws_eip.dmz_eip)
  allocation_id = aws_eip.dmz_eip[count.index].id
  subnet_id     = local.nat_subnet[count.index]
  tags = {
    Name = "${local.names[count.index]}_ngw"
 }
 depends_on = [aws_internet_gateway.gw_internet]
}

# # ################################ b. dev_dmz ################################

# resource "aws_nat_gateway" "gw_dev_nat" {
#   allocation_id = aws_eip.dmz_eip[1]
#   subnet_id     = aws_subnet.subnet_dev_dmz_pub[0]
#   tags = {
#     Name = "${local.names[1]}_ngw"
#  }
#  depends_on = [aws_internet_gateway.gw_internet]
# }
