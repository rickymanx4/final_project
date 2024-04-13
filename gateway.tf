##############################################################################
################################## 1. Elastic IP##############################
##############################################################################
resource "aws_eip" "dmz_eip" {
  #domain = "vpc"
  count =  4
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
  vpc_id = local.dmz_vpc[count.index]
  
  tags = {
    Name = element(var.name, count.index)
 }
}

##############################################################################
############################3. Nat Gateways###################################
##############################################################################

################################ a. user_dmz ################################

resource "aws_nat_gateway" "gw_user_nat" {
  count = 2
  allocation_id = local.user_eip[count.index]
  subnet_id     = local.user_sub[count.index]
  tags = {
    Name = "${local.names[0]}_ngw_${local.az_ac[count.index]}"
 }
 depends_on = [aws_internet_gateway.gw_internet]
}

# ################################ b. dev_dmz ################################

resource "aws_nat_gateway" "gw_dev_nat" {
  count = 2
  allocation_id = local.dev_eip[count.index]
  subnet_id     = local.dev_sub[count.index]
  tags = {
    Name = "${local.names[1]}_ngw_${local.az_ac[count.index]}"
 }
 depends_on = [aws_internet_gateway.gw_internet]
}
