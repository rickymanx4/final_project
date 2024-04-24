##############################################################################
################################### 1. Subnet ################################
##############################################################################

################################ a. user_dmz ################################

resource "aws_subnet" "subnet_user_dmz_pub" {
  count               = length(local.user_dmz_pub_subnet)
  vpc_id              = aws_vpc.project_vpc[0].id
  cidr_block          = element(local.user_dmz_pub_subnet, count.index)
  availability_zone   = element(local.azs_6, count.index)

  tags = {
    Name = "${local.names[0]}-pub-0${count.index+1}-${local.userdev_rt_name[count.index]}-${local.az_ac_6[count.index]}"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_user_dmz_pri" {
  count               = length(local.user_dmz_pri_subnet)
  vpc_id              = aws_vpc.project_vpc[0].id
  cidr_block          = element(local.user_dmz_pri_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[0]}-subnet-pri-0${count.index+1}-${local.userdev_rt_name[4]}-${local.az_ac[count.index]}"
  }
  map_public_ip_on_launch = false
}


################################ b. dev_dmz ################################


resource "aws_subnet" "subnet_dev_dmz_pub" {
  count               = length(local.dev_dmz_pub_subnet)
  vpc_id              = aws_vpc.project_vpc[1].id
  cidr_block          = element(local.dev_dmz_pub_subnet, count.index)
  availability_zone   = element(local.azs_6, count.index)

  tags = {
    Name = "${local.names[1]}-subnet-pub-0${count.index+1}-${local.userdev_rt_name[count.index]}-${local.az_ac_6[count.index]}"
  }
  map_public_ip_on_launch = true
}
resource "aws_subnet" "subnet_dev_dmz_pri" {
  count               = length(local.dev_dmz_pri_subnet)
  vpc_id              = aws_vpc.project_vpc[1].id
  cidr_block          = element(local.dev_dmz_pri_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[1]}-subnet-pri-0${count.index+1}-${local.userdev_rt_name[4]}-${local.az_ac[count.index]}"
  }
  map_public_ip_on_launch = false
}

################################ c. shared ################################

resource "aws_subnet" "subnet_shared_pri_01" {
  count               = length(local.shared_01_subnet)
  vpc_id              = aws_vpc.project_vpc[2].id
  cidr_block          = element(local.shared_01_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[2]}-subnet-pri-01-${local.shared_rt_name[0]}-${local.az_ac[count.index]}"
  }
  map_public_ip_on_launch = false
}

resource "aws_subnet" "subnet_shared_pri_02" {
  count               = length(local.shared_02_subnet)
  vpc_id              = aws_vpc.project_vpc[2].id
  cidr_block          = element(local.shared_02_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[2]}-subnet-pri-02-${local.userdev_rt_name[1]}-${local.az_ac[count.index]}"
  }
  map_public_ip_on_launch = false
}

################################ d. product ################################

resource "aws_subnet" "subnet_product_pri" {
  count               = length(local.product_subnet)
  vpc_id              = aws_vpc.project_vpc[3].id
  cidr_block          = element(local.product_subnet, count.index)
  availability_zone   = element(local.azs_6, count.index)

  tags = {
    Name = "${local.names[3]}-subnet-pri-${local.prodtest_rt_name[count.index]}-${local.az_ac_6[count.index]}"
  }
  map_public_ip_on_launch = false
}

# resource "aws_subnet" "subnet_product_pri_02" {
#   count               = length(local.product_subnet)
#   vpc_id              = aws_vpc.project_vpc[3].id
#   cidr_block          = element(local.product_subnet, count.index)
#   availability_zone   = element(local.azs_6, count.index)

#   tags = {
#     Name = "${local.names[3]}-subnet-pri-${local.prodtest_rt_name[1]}-${local.az_ac[count.index]}"
#   }
#   map_public_ip_on_launch = false
# }

################################ e. testdev ################################

resource "aws_subnet" "subnet_testdev_pri" {
  count               = length(local.testdev_subnet)
  vpc_id              = aws_vpc.project_vpc[4].id
  cidr_block          = element(local.testdev_subnet, count.index)
  availability_zone   = element(local.azs_6, count.index)

  tags = {
    Name = "${local.names[4]}-subnet-pri-${local.prodtest_rt_name[count.index]}-${local.az_ac_6[count.index]}"
  }
  map_public_ip_on_launch = false
}

# resource "aws_subnet" "subnet_testdev_pri_02" {
#   count               = length(local.testdev_02_subnet)
#   vpc_id              = aws_vpc.project_vpc[4].id
#   cidr_block          = element(local.testdev_02_subnet, count.index)
#   availability_zone   = element(local.azs_2, count.index)

#   tags = {
#     Name = "${local.names[4]}-subnet-pri-02-${local.prodtest_rt_name[1]}-${local.az_ac[count.index]}"
#   }
#   map_public_ip_on_launch = false
# }