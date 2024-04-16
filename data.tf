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

data "aws_ec2_transit_gateway_vpc_attachment" "shared_tgw_rt" {
  count   = 5
  filter {
    name   = "tag:Name"
    values = ["${local.names[count.index]}_tgw_attache"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
  depends_on = [ aws_ec2_transit_gateway.tgw_main ]  
}

data "aws_instance" "shared_tg_att_a" {
  count   = 3
  filter {
    name   = "tag:Name"
    values = ["${local.names[2]}_*_a"]
  }

  filter {
    name   = "instance_state"
    values = ["running"]
  }
  
  filter {
    name   = "availability_zone"
    values = ["ap-southeast-1a"]
  }
  depends_on = [ 
    aws_instance.shared_prometheus,
    aws_instance.shared_grafana,
    aws_instance.shared_elk  
   ]  
}

data "aws_instance" "shared_tg_att_c" {
  count   = 3
  filter {
    name   = "tag:Name"
    values = ["${local.names[2]}_*_c"]
  }

  filter {
    name   = "instance_state"
    values = ["running"]
  }
  
  filter {
    name   = "availability_zone"
    values = ["ap-southeast-1c"]
  }
  depends_on = [ 
    aws_instance.shared_prometheus,
    aws_instance.shared_grafana,
    aws_instance.shared_elk  
   ]  
}
