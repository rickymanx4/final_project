# ##############################################################################
# #################################### 1.user_dmz_ec2 ##########################
# ##############################################################################

# resource "aws_instance" "user_dmz_proxy" {
#   count                       = 2
#   ami                         = data.aws_ami.amazon_linux_2023.id
#   instance_type               = "t2.small" 
#   vpc_security_group_ids      = [aws_security_group.dmz_proxy_sg[0].id]
#   key_name                    = aws_key_pair.ec2_key.key_name
#   subnet_id                   = aws_subnet.subnet_user_dmz_pri[count.index].id
#   associate_public_ip_address = false
#   #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
#   # depends_on=[
#   #   aws_efs_file_system.web_efs,
#   #   aws_efs_mount_target.web_mount
#   #   ]
#   user_data = file("./user-data-proxy.sh")
#   tags = {
#     Name = "${local.names[0]}_proxy_${local.az_ac[count.index]}"
#   }
# }

# ##############################################################################
# #################################### 2.dev_dmz_ec2 ###########################
# ##############################################################################

# resource "aws_instance" "dev_dmz_proxy" {
#   count                       = 2
#   ami                         = data.aws_ami.amazon_linux_2023.id
#   instance_type               = "t2.small" 
#   vpc_security_group_ids      = [aws_security_group.dmz_proxy_sg[1].id]
#   key_name                    = aws_key_pair.ec2_key.key_name
#   subnet_id                   = aws_subnet.subnet_dev_dmz_pri[count.index].id
#   associate_public_ip_address = false
#   #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
#   # depends_on=[
#   #   aws_efs_file_system.web_efs,
#   #   aws_efs_mount_target.web_mount
#   #   ]
#   user_data = file("./user-data-proxy.sh")
#   tags = {
#     Name = "${local.names[1]}_proxy_${local.az_ac[count.index]}"
#   }
# }

##############################################################################
#################################### 3.shared_ec2 ############################
##############################################################################

################################ a. nexus_ec2 ################################

resource "aws_instance" "shared_nexus" {
  count                       = 2
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.small" 
  vpc_security_group_ids      = [aws_security_group.shared_nexus_sg.id]
  key_name                    = aws_key_pair.ec2_key.key_name
  subnet_id                   = aws_subnet.subnet_shared_pri_01[count.index].id
  associate_public_ip_address = false
  #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
  # depends_on=[
  #   aws_efs_file_system.web_efs,
  #   aws_efs_mount_target.web_mount
  #   ]
  user_data = file("./user-data-proxy.sh")
  tags = {
    Name = "${local.names[2]}_ec2_nexus_${local.az_ac[count.index]}"
  }
}

################################ b. monitoring_ec2 ################################

resource "aws_instance" "shared_prometheus" {
  count                       = 2
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.small" 
  vpc_security_group_ids      = [aws_security_group.shared_monitoring_sg.id]
  key_name                    = aws_key_pair.ec2_key.key_name
  subnet_id                   = aws_subnet.subnet_shared_pri_02[count.index].id
  associate_public_ip_address = false
  #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
  # depends_on=[
  #   aws_efs_file_system.web_efs,
  #   aws_efs_mount_target.web_mount
  #   ]
  #user_data = file("./user-data-nginx.sh")
  tags = {
    Name = "${local.names[2]}_${local.shared_ec2_name[0]}_${local.az_ac[count.index]}"
  }
}

resource "aws_instance" "shared_grafana" {
  count                       = 2
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.small" 
  vpc_security_group_ids      = [aws_security_group.shared_monitoring_sg.id]
  key_name                    = aws_key_pair.ec2_key.key_name
  subnet_id                   = aws_subnet.subnet_shared_pri_02[count.index].id
  associate_public_ip_address = false
  #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
  # depends_on=[
  #   aws_efs_file_system.web_efs,
  #   aws_efs_mount_target.web_mount
  #   ]
  #user_data = file("./user-data-nginx.sh")
  # provisioner "file" {
  #   source = var.private_key_location
  #   destination = "."
  # }  
  #   connection {
  #     type        = "ssh"
  #     user        = "ec2-user"
  #     private_key = file("./ec2_key")
  #     port        = 9999 
  #     host        = aws_lb.dev_dmz_proxy_lb[count.index].dns_name
  #   }    
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo chmod 400 ${var.private_key_location}"
  #   ]
  # }  
  tags = {
    Name = "${local.names[2]}_${local.shared_ec2_name[1]}_${local.az_ac[count.index]}"
  }
}



################################ c. elk_ec2 ################################

resource "aws_instance" "shared_elk" {  
  count                       = 2
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.small" 
  vpc_security_group_ids      = [aws_security_group.shared_elk_sg.id]
  key_name                    = aws_key_pair.ec2_key.key_name
  subnet_id                   = aws_subnet.subnet_shared_pri_02[count.index].id
  associate_public_ip_address = false
  #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
  # depends_on=[
  #   aws_efs_file_system.web_efs,
  #   aws_efs_mount_target.web_mount
  #   ]
  #user_data = file("./user-data-nginx.sh")
  tags = {
    Name = "${local.names[2]}_elk_${local.az_ac[count.index]}"
  }
}
