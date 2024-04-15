###
# 1. amazon linux 2023 AMI
###
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_network_interface" "lb_ni" {
count = 2

  filter {
    name   = "description"
    values = ["ELB net/${aws_lb.shared_ext_lb[count.index].name}/*"]
  }
  filter {
    name   = "subnet-id"
    values = [aws_subnet.subnet_shared_pri_01[count.index].id]
  }
}

data "aws_ec2_transit_gateway_vpc_attachment" "shared_all" {
  filter {
    name   = "tag:Name"
    values = ["${local.names[*]}_tgw_attache"]
  }

    filter {
    name   = "state"
    values = ["available"]
  }
}


# data "aws_subnet" "shared_control" {
#   count    = 2
#   filter {
#     name   = "tag:Name"
#     values = ["shared-subnet-pri-02", "shared-subnet-pri-04"]
#   }
# }
