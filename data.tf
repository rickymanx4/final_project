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
  depends_on = [ 
    aws_ec2_transit_gateway_vpc_attachment.user_dmz,
    aws_ec2_transit_gateway_vpc_attachment.dev_dmz,
    aws_ec2_transit_gateway_vpc_attachment.shared,
    aws_ec2_transit_gateway_vpc_attachment.product,
    aws_ec2_transit_gateway_vpc_attachment.testdev,
    ]  
}

# data "aws_instances" "shared_tg_att_a" {
#   filter {
#     name   = "instance-state-name"
#     values = ["running"]
#   }
  
  # filter {
  #   name   = "subnet-id"
  #   values = ["aws_subnet.subnet_shared_pri_02[0].id"]
  # }

#   filter {
#     name   = "tag:Name"
#     values = ["${local.names[2]}_${local.shared_ec2_name[*]}_a"]
#   }  
#   depends_on = [ 
#     aws_instance.shared_prometheus,
#     aws_instance.shared_grafana,
#     aws_instance.shared_elk  
#    ]  
# }

