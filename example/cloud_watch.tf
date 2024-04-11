############### create cloudwatch log group ###########
resource "aws_cloudwatch_log_group" "web_blind_access" {
  name              = "web_blind_access" # The name of the log group.
  retention_in_days = 14 # Retention of logs in days.
}
resource "aws_cloudwatch_log_group" "web_blind_error" {
  name              = "web_blind_error" # The name of the log group.
  retention_in_days = 14 # Retention of logs in days.
}
resource "aws_cloudwatch_log_group" "app_blind_access" {
  name              = "app_blind_access" # The name of the log group.
  retention_in_days = 14 # Retention of logs in days.
}
resource "aws_cloudwatch_log_group" "app_blind_error" {
  name              = "app_blind_error" # The name of the log group.
  retention_in_days = 14 # Retention of logs in days.
}

############### 오토스케일링 그룹에 경보 적용 #########
resource "aws_autoscaling_policy" "web_scale_out" {
  name                   = "scale_out_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}
resource "aws_autoscaling_policy" "app_scale_out" {
  name                   = "scale_out_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

############## 경보 생성 ##############
resource "aws_cloudwatch_metric_alarm" "cpu_alarm-web" {
  alarm_name          = "CPUUtilizationHigh_Web"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.web_scale_out.arn]
}
resource "aws_cloudwatch_metric_alarm" "cpu_alarm-app" {
  alarm_name          = "CPUUtilizationHigh_APP"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.web_scale_out.arn]
}

############### SNS 주제 생성 ############
resource "aws_sns_topic" "example_topic_web" {
  name = "example-topic_web"
}
resource "aws_sns_topic" "example_topic_app" {
  name = "example-topic_app"
}

################ 이메일 엔드포인트 추가 ####
resource "aws_sns_topic_subscription" "email_subscription_web" {
  topic_arn = aws_sns_topic.example_topic_web.arn
  protocol  = "email"
  endpoint  = "illidan2000@naver.com" # 여기에 이메일 주소를 입력하세요
}
resource "aws_sns_topic_subscription" "email_subscription_app" {
  topic_arn = aws_sns_topic.example_topic_app.arn
  protocol  = "email"
  endpoint  = "illidan2000@naver.com" # 여기에 이메일 주소를 입력하세요
}

###
# 1. copy Cloudwatch configuration file
###
resource "null_resource" "copy_config_file" {
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/terraform-key")}"
    host = "${aws_instance.project_bastion.public_ip}"
  }
  provisioner "file" {
    source = "./config.json_web.j2"
    destination = "${var.dest2}/"
  }
  provisioner "file" {
    source = "./config.json_app.j2"
    destination = "${var.dest2}/"
  }

  depends_on = [
    aws_instance.project_bastion,
    null_resource.copy_files
  ]
}
###
# 2. install & configurate CloudWatch
###
resource "null_resource" "install_cloudwatch_web" {
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/terraform-key")}"
    host = "${aws_instance.project_bastion.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo yum install -y amazon-cloudwatch-agent'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo systemctl enable --now amazon-cloudwatch-agent'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo rpm -U ./amazon-cloudwatch-agent.rpm'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo chown ec2-user /opt/aws/amazon-cloudwatch-agent/bin'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo yum install collectd -y'",
      "sudo scp -i ${var.dest1} -o StrictHostKeyChecking=no -r ${var.dest2}/config.json_web.j2 ec2-user@${aws_instance.project_web.private_ip}:/opt/aws/amazon-cloudwatch-agent/bin/config.json",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo chown ec2-user:ec2-user /opt/aws/amazon-cloudwatch-agent/bin/config.json'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo chmod 755 /opt/aws/amazon-cloudwatch-agent/bin/config.json'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo systemctl restart amazon-cloudwatch-agent'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_web.private_ip} 'sudo systemctl enable --now collectd'"
    ]
  }

  depends_on = [ null_resource.copy_config_file ]
}

resource "null_resource" "install_cloudwatch_app" {
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/terraform-key")}"
    host = "${aws_instance.project_bastion.public_ip}"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo yum install -y amazon-cloudwatch-agent'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo systemctl enable --now amazon-cloudwatch-agent'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo rpm -U ./amazon-cloudwatch-agent.rpm'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo chown ec2-user /opt/aws/amazon-cloudwatch-agent/bin'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo yum install collectd -y'",
      "sudo scp -i ${var.dest1} -o StrictHostKeyChecking=no -r ${var.dest2}/config.json_app.j2 ec2-user@${aws_instance.project_app.private_ip}:/opt/aws/amazon-cloudwatch-agent/bin/config.json",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo chown ec2-user:ec2-user /opt/aws/amazon-cloudwatch-agent/bin/config.json'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo chmod 755 /opt/aws/amazon-cloudwatch-agent/bin/config.json'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo systemctl restart amazon-cloudwatch-agent'",
      "sudo ssh -i ${var.dest1} -o StrictHostKeyChecking=no ec2-user@${aws_instance.project_app.private_ip} 'sudo systemctl enable --now collectd'"
    ]
  }

  depends_on = [ null_resource.copy_config_file ]
}