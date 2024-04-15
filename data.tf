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
    values = [data.aws_subnet.shared_nexus[count.index].id]
  }
}

data "aws_subnet" "shared_nexus" {

  filter {
    name   = "tags"
    values = ["shared-subnet-pri-01", "shared-subnet-pri-03"]
  }
}


data "aws_subnet" "shared_control" {

  filter {
    name   = "tags"
    values = ["shared-subnet-pri-02", "shared-subnet-pri-04"]
  }
}
