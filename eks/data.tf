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

###
# 2. load balancer eni private ip
###
# shared internal loadbalancer
data "aws_network_interface" "shared_ext" {
count = 2

  filter {
    name   = "description"
    values = ["ELB net/${aws_lb.shared_ext.name}/*"]
  }
  filter {
    name   = "subnet-id"
    values = [ aws_subnet.shared_tgw[count.index].id ]
  }
}
#### test ####
