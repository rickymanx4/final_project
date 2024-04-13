##############################################################################
################################### 1. Subnet ################################
##############################################################################

################################ a. user_dmz ################################

resource "aws_subnet" "user_dmz_pub_subnet" {
  count               = length(local.user_dmz_pub_subnet)
  vpc_id              = aws_vpc.project_vpc[0].id
  cidr_block          = element(local.user_dmz_pub_subnet, count.index)
  availability_zone   = element(local.azs_4, count.index)

  tags = {
    Name = "${local.names[0]}-subnet-pub-0${count.index+1}"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "user_dmz_pri_subnet" {
  count               = length(local.user_dmz_pri_subnet)
  vpc_id              = aws_vpc.project_vpc[0].id
  cidr_block          = element(local.user_dmz_pri_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[0]}-subnet-pri-0${count.index+1}"
  }
  map_public_ip_on_launch = false
}


################################ b. dev_dmz ################################


resource "aws_subnet" "dev_dmz_pub_subnet" {
  count               = length(local.dev_dmz_pub_subnet)
  vpc_id              = aws_vpc.project_vpc[1].id
  cidr_block          = element(local.dev_dmz_pub_subnet, count.index)
  availability_zone   = element(local.azs_4, count.index)

  tags = {
    Name = "${local.names[1]}-subnet-pub-0${count.index+1}"
  }
  map_public_ip_on_launch = true
}
resource "aws_subnet" "dev_dmz_pri_subnet" {
  count               = length(local.dev_dmz_pri_subnet)
  vpc_id              = aws_vpc.project_vpc[1].id
  cidr_block          = element(local.dev_dmz_pri_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[1]}-subnet-pri-0${count.index+1}"
  }
  map_public_ip_on_launch = false
}

################################ c. shared ################################

resource "aws_subnet" "shared_dmz_pri_subnet" {
  count               = length(local.shared_pri_subnet)
  vpc_id              = aws_vpc.project_vpc[2].id
  cidr_block          = element(local.shared_pri_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[2]}-subnet-pri-0${count.index+1}"
  }
  map_public_ip_on_launch = false
}

################################ d. product ################################

resource "aws_subnet" "product_pri_01_subnet" {
  count               = length(local.product_01_subnet)
  vpc_id              = aws_vpc.project_vpc[3].id
  cidr_block          = element(local.product_01_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[3]}-subnet-pri-01-${local.az_ac[count.index]}"
  }
  map_public_ip_on_launch = false
}

resource "aws_subnet" "product_pri_02_subnet" {
  count               = length(local.product_02_subnet)
  vpc_id              = aws_vpc.project_vpc[3].id
  cidr_block          = element(local.product_02_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[3]}-subnet-pri-02-${local.az_ac[count.index]}"
  }
  map_public_ip_on_launch = false
}

################################ e. testdev ################################

resource "aws_subnet" "testdev_pri_01_subnet" {
  count               = length(local.testdev_01_subnet)
  vpc_id              = aws_vpc.testdev_vpc[3].id
  cidr_block          = element(local.testdev_01_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[4]}-subnet-pri-01-${local.az_ac[count.index]}"
  }
  map_public_ip_on_launch = false
}

resource "aws_subnet" "testdev_pri_02_subnet" {
  count               = length(local.testdev_02_subnet)
  vpc_id              = aws_vpc.testdev_vpc[3].id
  cidr_block          = element(local.testdev_02_subnet, count.index)
  availability_zone   = element(local.azs_2, count.index)

  tags = {
    Name = "${local.names[4]}-subnet-pri-02-${local.az_ac[count.index]}"
  }
  map_public_ip_on_launch = false
}