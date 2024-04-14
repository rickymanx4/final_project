##############################################################################
#################################### 1.user_dmz_ec2 ##########################
##############################################################################

resource "aws_instance" "user_dmz_proxy" {
  count = 2
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.dmz_proxy_sg[0].id]
  key_name = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.user_dmz_pub_subnet[count.index].id
  associate_public_ip_address = false
  #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
  # depends_on=[
  #   aws_efs_file_system.web_efs,
  #   aws_efs_mount_target.web_mount
  #   ]
  user_data = <<-EOF
  #!/bin/bash
  sudo dnf install -y nginx
  sudo systemctl enable --now nginx
  EOF
  tags = {
    Name = "${local.names[0]}_proxy_${local.az_ac[count.index]}"
  }
}

##############################################################################
#################################### 2.dev_dmz_ec2 ###########################
##############################################################################

resource "aws_instance" "dev_dmz_proxy" {
  count = 2
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.dmz_proxy_sg[1].id]
  key_name = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.dev_dmz_pub_subnet[count.index].id
  associate_public_ip_address = false
  #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
  # depends_on=[
  #   aws_efs_file_system.web_efs,
  #   aws_efs_mount_target.web_mount
  #   ]
  user_data = <<-EOF
  #!/bin/bash
  sudo dnf install -y nginx
  sudo systemctl enable --now nginx
  EOF
  tags = {
    Name = "${local.names[1]}_proxy_${local.az_ac[count.index]}"
  }
}

##############################################################################
#################################### 3.shared_ec2 ############################
##############################################################################

################################ a. nexus_ec2 ################################

resource "aws_instance" "shared_nexus" {
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.shared_nexus_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.shared_pri_subnet[0].id
  associate_public_ip_address = false
  #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
  # depends_on=[
  #   aws_efs_file_system.web_efs,
  #   aws_efs_mount_target.web_mount
  #   ]
  user_data = <<-EOF
  #!/bin/bash
  sudo dnf install -y nginx
  sudo systemctl enable --now nginx
  EOF
  tags = {
    Name = "${local.names[2]}_nexus_ec2"
  }
}

################################ b. monitoring_ec2 ################################

resource "aws_instance" "shared_monitoring" {
  count = 2
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.shared_monitoring_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.shared_pri_subnet[1].id
  associate_public_ip_address = false
  #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
  # depends_on=[
  #   aws_efs_file_system.web_efs,
  #   aws_efs_mount_target.web_mount
  #   ]
  user_data = <<-EOF
  #!/bin/bash
  sudo dnf install -y nginx
  sudo systemctl enable --now nginx
  EOF
  tags = {
    Name = element(var.monitoring_ec2, count.index)
  }
}

################################ c. elk_ec2 ################################

resource "aws_instance" "shared_elk" {  
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.shared_elk_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.shared_pri_subnet[1].id
  associate_public_ip_address = false
  #iam_instance_profile = aws_iam_instance_profile.testbed_cloudwatch_profile.name
  # depends_on=[
  #   aws_efs_file_system.web_efs,
  #   aws_efs_mount_target.web_mount
  #   ]
  user_data = <<-EOF
  #!/bin/bash
  sudo dnf install -y nginx
  sudo systemctl enable --now nginx
  EOF
  tags = {
    Name = "${local.names[2]}_elk_ec2"
  }
}
