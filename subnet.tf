###
# 1. Public Subnet
###
resource "aws_subnet" "public" {
  for_each = var.subnet
  vpc_id     = aws_vpc.project_vpc.id 
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = "each.value.name"
  }
  map_public_ip_on_launch = each.value.pub
}
