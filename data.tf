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

data "aws_subnet" "nat_subnet" {
count = 2

  filter {
    name   = "tag:Name"
    values = ["${local.names[count.index]}-pub-nat-a"]
  }
  depends_on = [ 
    aws_subnet.subnet_user_dmz_pub,
    aws_subnet.subnet_dev_dmz_pub
    ]    
}


data "aws_subnet" "user_nwf_subnet" {
count = 2
  filter {
    name   = "tag:Name"
    values = ["${local.names[0]}-pub-nwf-${local.az_ac[count.index]}"]
  }
  depends_on = [ aws_subnet.subnet_user_dmz_pub ]    
}

data "aws_subnet" "dev_nwf_subnet" {
count = 2
  filter {
    name   = "tag:Name"
    values = ["${local.names[1]}-pub-nwf-${local.az_ac[count.index]}"]
  }
  depends_on = [ aws_subnet.subnet_dev_dmz_pub ]    
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

data "aws_network_interfaces" "nexus_nlb_ni" {
  # count =2
  filter {
    name   = "description"
    values = ["ELB net/dev-dmz-nexus-lb/*"]
  }
  # filter {
  #   name   = "subnet-id"
  #   values = [aws_subnet.subnet_dev_dmz_pub[count.index+4].id]
  # }
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
data "aws_vpc_endpoint" "user_nwf_endpoints" {
  count =2
  vpc_id   = aws_vpc.project_vpc[0].id
  #subnet_ids = [aws_subnet.subnet_user_dmz_pub[count.index + 2].id]
  filter {
    name   = "cidr_blocks"
    values = [local.user_dmz_pub_subnet[count.index + 2]]
  }
}  

data "aws_vpc_endpoint" "dev_nwf_endpoints" {
  count =2
  vpc_id   = aws_vpc.project_vpc[1].id
  #subnet_ids = [aws_subnet.subnet_dev_dmz_pub[count.index + 2].id]
  filter {
    name   = "cidr_blocks"
    values = [local.dev_dmz_pub_subnet[count.index + 2]]
  }
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

