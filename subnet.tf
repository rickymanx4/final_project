###
# 1. Public Subnet
###
resource "aws_subnet" "subnet_user_dmz" {
  vpc_id  = "$(aws_vpc.project_vpc[0].id)" 
  for_each = var.subnet_user_dmz
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = "each.value.name"
  }
  map_public_ip_on_launch = each.value.pub
}

resource "aws_subnet" "subnet_dev_dmz" {
  vpc_id  = "$(aws_vpc.project_vpc[1].id)" 
  for_each = var.subnet_dev_dmz
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = "each.value.name"
  }
  map_public_ip_on_launch = each.value.pub
}

resource "aws_subnet" "subnet_shared" {
  vpc_id  = "$(aws_vpc.project_vpc[2].id)" 
  for_each = var.subnet_shared
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = "each.value.name"
  }
  map_public_ip_on_launch = each.value.pub
}

resource "aws_subnet" "subnet_product" {
  vpc_id  = "$(aws_vpc.project_vpc[3].id)" 
  for_each = var.subnet_product
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = "each.value.name"
  }
  map_public_ip_on_launch = each.value.pub
}

resource "aws_subnet" "subnet_testdev" {
  vpc_id  = "$(aws_vpc.project_vpc[4].id)" 
  for_each = var.subnet_testdev
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = "each.value.name"
  }
  map_public_ip_on_launch = each.value.pub
}