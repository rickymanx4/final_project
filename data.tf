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

data "aws_security_group" "proxy_sg" {
count = 2

  filter {
    name   = "tag:Name"
    values = ["${local.names[count.index]}_proxy_sg"]
  }
  depends_on = [ 
    aws_security_group.user_dmz_sg,
    aws_security_group.dev_dmz_sg
    ]    
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

data "aws_lb" "user_alb_arn" {
  count  = 2 
  name = "user-dmz-proxy-lb-${local.az_ac[count.index]}"
  depends_on = [ 
    aws_lb.user_dmz_proxy_lb
  ]  
}

data "aws_lb" "dev_alb_arn" {
  count  = 2 
  name = "dev-dmz-proxy-lb-${local.az_ac[count.index]}"
  depends_on = [ 
    aws_lb.dev_dmz_proxy_lb
  ]  
}

data "aws_wafv2_web_acl" "cf_wacl" {
  name      = "cf-wacl"
  scope     = "CLOUDFRONT"
  provider  = aws.virginia
  depends_on = [ 
    aws_wafv2_web_acl.cf_wacl
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

