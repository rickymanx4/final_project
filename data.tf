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
    values = "ELB ${aws_lb.shared-ext-lb[count.index]}"
  }
  filter {
    name   = "subnet-id"
    values = local.shared_pri_subnet[count.index]
  }
}
