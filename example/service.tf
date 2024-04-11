##################
# command to bastion
##################
resource "null_resource" "copy_files" {
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/terraform-key")}"
    host = "${aws_instance.project_bastion.public_ip}"
  }
  provisioner "file" {
    source = var.private_key_location
    destination = "${var.dest1}"
  }
  provisioner "file" {
    source = "./service"
    destination = "${var.dest2}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 ${var.dest1}"
    ]
  }

  depends_on = [aws_instance.project_bastion]
}
##################
# Define LB DNS Name
##################
resource "null_resource" "define_lb_dns" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/.ssh/terraform-key")}"
    host        = "${aws_instance.project_bastion.public_ip}"
  }

  count = length(var.flask_file_paths)
  provisioner "remote-exec" {
    inline = [
      "sed -i 's/INT_LB_DNS/${aws_alb.internal_lb.dns_name}/g'  ${element(var.flask_file_paths, count.index)}"
    ]
  }

  depends_on = [
    aws_instance.project_bastion,
    null_resource.copy_files,
    aws_alb.internal_lb,
  ]
}

##################
# Define RDS END Point 
##################
resource "null_resource" "define_rds_end_point" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/.ssh/terraform-key")}"
    host        = "${aws_instance.project_bastion.public_ip}"
  }

  count = length(var.dao_file_paths)
  provisioner "remote-exec" {
    inline = [
      "sed -i 's/RDS_END_POINT/${aws_db_instance.blind_rds.address}/g' ${element(var.dao_file_paths, count.index)}"
    ]
  }

  depends_on = [
    aws_instance.project_bastion,
    null_resource.copy_files,
    aws_db_instance.blind_rds,
  ]
}
##################
# copy file to web layer
##################
resource "null_resource" "web_service_copy" {
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/terraform-key")}"
    host = "${aws_instance.project_bastion.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo chown ec2-user:ec2-user -R ${var.efs_mount_point}'",
      "sudo scp -i ${var.dest1} -o StrictHostKeyChecking=no -r ${var.dest2}/blind_web ec2-user@${aws_instance.project_web.private_ip}:${var.efs_mount_point}",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo chmod 755 -R ${var.efs_mount_point}'",
      "sudo scp -i ${var.dest1} -o StrictHostKeyChecking=no -r ${var.dest2}/web.tpl ec2-user@${aws_instance.project_web.private_ip}:${var.efs_mount_point}/blind_web.service",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo cp ${var.efs_mount_point}/blind_web.service /etc/systemd/system/blind_web.service'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo systemctl daemon-reload'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo chmod 755 ${var.efs_mount_point}/blind_web.service'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo systemctl enable --now blind_web.service'"
    ]
  }

  depends_on = [
    aws_instance.project_bastion,
    null_resource.copy_files,
    null_resource.define_lb_dns,
    null_resource.define_rds_end_point
    ]
}

##################
# copy to app
##################
resource "null_resource" "app_service_copy" {
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/terraform-key")}"
    host = "${aws_instance.project_bastion.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo chown ec2-user:ec2-user -R ${var.efs_mount_point}'",
      "sudo scp -i ${var.dest1} -o StrictHostKeyChecking=no -r ${var.dest2}/blind_was ec2-user@${aws_instance.project_app.private_ip}:${var.efs_mount_point}",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo chmod 755 -R ${var.efs_mount_point}'",
      "sudo scp -i ${var.dest1} -o StrictHostKeyChecking=no -r ${var.dest2}/was.tpl ec2-user@${aws_instance.project_app.private_ip}:${var.efs_mount_point}/blind_was.service",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo chmod 755 ${var.efs_mount_point}/blind_was.service'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo cp ${var.efs_mount_point}/blind_was.service /etc/systemd/system/blind_was.service'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo systemctl daemon-reload'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo systemctl enable --now blind_was.service'"
    ]
  }

  depends_on = [
    aws_instance.project_bastion,
    null_resource.copy_files,
    null_resource.define_rds_end_point
    ]
}

##################
# Input Dummy Data 
##################
resource "null_resource" "input_dummy_data" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/.ssh/terraform-key")}"
    host        = "${aws_instance.project_bastion.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo scp -i ${var.dest1} -o StrictHostKeyChecking=no -r ${var.dest2}/dummy_data.sql ec2-user@${aws_instance.project_app.private_ip}:${var.dest_dummy_data}",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo mariadb -u ${var.db_user_name} -p'${var.db_user_pass}' -P 3306 -h ${aws_db_instance.blind_rds.address} blind < ${var.dest_dummy_data}'"
    ]
  }
  depends_on = [
    aws_instance.project_bastion,
    null_resource.copy_files,
    aws_db_instance.blind_rds,
    null_resource.app_service_copy
  ]
}

##################
# clean the bastion
##################

resource "null_resource" "delete_service_bastion" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/.ssh/terraform-key")}"
    host        = "${aws_instance.project_bastion.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf ${var.dest2}"
    ]
  }
  depends_on = [
    aws_instance.project_bastion,
    null_resource.copy_files,
    null_resource.web_service_copy,
    null_resource.app_service_copy,
    null_resource.input_dummy_data,
    null_resource.install_cloudwatch_web,
    null_resource.install_cloudwatch_app
  ]
}

##################
# monitoring
# aws AccessKey 기입 후 실행
# nsible/role/prometheus/template/prometheus.yml.j2
# ansible/role/cred.yaml
##################
resource "null_resource" "install_monitoring" {
  provisioner "local-exec" {
    working_dir = "./ansible"
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yaml"
  }
  depends_on = [
      null_resource.delete_service_bastion     
    ]
}