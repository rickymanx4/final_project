###
# 1. Public Subnet
###
resource "aws_subnet" "subnet_user_dmz" {
  vpc_id  = aws_vpc.project_vpc[0] 
  for_each = var.subnet_user_dmz
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = "each.value.name"
  }
  map_public_ip_on_launch = each.value.pub
}
