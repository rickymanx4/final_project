###
# 1. Public Subnet
###
resource "aws_subnet" "user_dmz_pub_subnet" {
  vpc_id  = aws_vpc.project_vpc["user_dmz_vpc"].id
  for_each = var.subnet_user_dmz_pub
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = each.value.name
  }
  map_public_ip_on_launch = each.value.pub
  depends_on = [ aws_vpc.project_vpc ]
}

resource "aws_subnet" "user_dmz_pri_subnet" {
  vpc_id  = aws_vpc.project_vpc["user_dmz_vpc"].id
  for_each = var.subnet_user_dmz_pri
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = each.value.name
  }
  map_public_ip_on_launch = each.value.pub
  depends_on = [ aws_vpc.project_vpc ]
}

resource "aws_subnet" "dev_dmz_pub_subnet" {
  vpc_id  = aws_vpc.project_vpc["dev_dmz_vpc"].id
  for_each = var.subnet_dev_dmz_pub
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = each.value.name
  }
  map_public_ip_on_launch = each.value.pub
  depends_on = [ aws_vpc.project_vpc ]
}

resource "aws_subnet" "dev_dmz_pri_subnet" {
  vpc_id  = aws_vpc.project_vpc["dev_dmz_vpc"].id
  for_each = var.subnet_dev_dmz_pri
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = each.value.name
  }
  map_public_ip_on_launch = each.value.pub
  depends_on = [ aws_vpc.project_vpc ]
}
resource "aws_subnet" "shared_subnet" {
  vpc_id  = aws_vpc.project_vpc["shared_vpc"].id
  for_each = var.subnet_shared
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = each.value.name
  }
  map_public_ip_on_launch = each.value.pub
  depends_on = [ aws_vpc.project_vpc ]
}

resource "aws_subnet" "product_subnet" {
  vpc_id  = aws_vpc.project_vpc["product_vpc"].id 
  for_each = var.subnet_product
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = each.value.name
  }
  map_public_ip_on_launch = each.value.pub
  depends_on = [ aws_vpc.project_vpc ]
}

resource "aws_subnet" "testdev_subnet" {
  vpc_id  = aws_vpc.project_vpc["testdev_vpc"].id 
  for_each = var.subnet_testdev
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = each.value.name
  }
  map_public_ip_on_launch = each.value.pub
  depends_on = [ aws_vpc.project_vpc ]
}