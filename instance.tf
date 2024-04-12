resource "aws_instance" "user_dmz_proxy" {
  for_each = var.subnet_user_dmz_pri
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.user_dmz_proxy_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.user_dmz_pri_subnet[each.key].id
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
    Name = "${each.value.tag}_proxy"
  }
}

resource "aws_instance" "dev_dmz_proxy" {
  for_each = var.subnet_dev_dmz_pri
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.dev_dmz_proxy_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.dev_dmz_pri_subnet[each.key].id
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
    Name = "${each.value.tag}_proxy"
  }
}

resource "aws_instance" "shared_nexus" {
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.security_group.shared_nexus_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.shared_subnet["shared_pri_01a"].id
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
    Name = "shared_nexus_ec2"
  }
}

resource "aws_instance" "shared_monitoring" {
  count = length(var.monitoring_ec2)
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.security_group.shared_monitoring_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.shared_subnet["shared_pri_02a"].id
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
    Name = "element(var.monitoring_ec2, count.index)_ec2"
  }
}

resource "aws_instance" "shared_elk" {  
  ami = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.small" 
  vpc_security_group_ids = [aws_security_group.security_group.shared_elk_sg.id]
  key_name = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.shared_subnet["shared_pri_02a"].id
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
    Name = "shared_elk_ec2"
  }
}


# resource "aws_instance" "project_bastion" {
#   ami = data.aws_ami.amazon_linux_2023.id
#   instance_type = "t2.small" 
#   vpc_security_group_ids = [aws_security_group.project_bastion.id]
#   key_name = aws_key_pair.terraform_key.key_name
#   subnet_id = aws_subnet.public[0].id
#   associate_public_ip_address = true
#   iam_instance_profile = aws_iam_instance_profile.blind_bastion_profile.name
#   # user_data = templatefile("./user-data-bastion.sh",{
#   #   web_efs_id = aws_efs_file_system.web_efs.id
#   #   mount_point = var.efs_mount_point
#   # })
#   depends_on = [ 
#     aws_instance.project_web,
#     aws_instance.project_app 
#     ]
#   tags = merge(var.testbed_tags,var.bastion_layer_tags,
#     {
#       Name = "project_bastion"
#     })
# }
# resource "aws_instance" "project_app" {
#   ami = data.aws_ami.amazon_linux_2023.id
#   instance_type = "t2.small" 
#   vpc_security_group_ids = [aws_security_group.project_app.id]
#   key_name = aws_key_pair.terraform_key.key_name
#   subnet_id = aws_subnet.app[0].id
#   associate_public_ip_address = false
#   iam_instance_profile   = aws_iam_instance_profile.testbed_cloudwatch_profile.name
#   depends_on=[
#     aws_efs_file_system.app_efs,
#     aws_efs_mount_target.app_mount
#     ]
#   user_data = templatefile("./user-data-app.sh",{
#     app_efs_id = aws_efs_file_system.app_efs.id
#     mount_point = var.efs_mount_point
#   })
#   tags = merge(var.testbed_tags,var.app_layer_tags,
#     {
#       Name = "project_APP"
#     }
#   )
# }
