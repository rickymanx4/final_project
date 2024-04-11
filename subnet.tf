###
# 1. Public Subnet
###
resource "aws_subnet" "all_subnet" {
  vpc_id  = aws_vpc.project_vpc.[each.key] 
  for_each = var.subnet
  cidr_block = each.value.cidr
  availability_zone = each.value.az
    tags = {
    Name = "each.value.name"
  }
  map_public_ip_on_launch = each.value.pub
}
