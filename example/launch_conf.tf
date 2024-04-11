resource "aws_launch_configuration" "web" {
  name_prefix = "web-" 
  image_id = aws_ami_from_instance.ami_web.id
  instance_type = "t2.small"
  key_name = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.project_web.id]
  associate_public_ip_address = false
  root_block_device {
    volume_type = "standard"
    volume_size = 12
  }
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "standard"
    volume_size = 10
    encrypted   ="false"
  }
  # user_data = templatefile("./user-data-web.sh",{
  #   web_efs_id = aws_efs_file_system.web_efs.id
  #   mount_point = var.efs_mount_point
  # })
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_launch_configuration" "app" {
  name_prefix = "app-" 
  image_id = aws_ami_from_instance.ami_app.id
  instance_type = "t2.small"
  key_name = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.project_app.id]
  associate_public_ip_address = false
  root_block_device {
    volume_type = "standard"
    volume_size = 12
  }
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "standard"
    volume_size = 10
    encrypted   ="false"
  }
  # user_data = templatefile("./user-data-app.sh",{
  #   app_efs_id = aws_efs_file_system.app_efs.id
  #   mount_point = var.efs_mount_point
  # })
  lifecycle {
    create_before_destroy = true
  }
}