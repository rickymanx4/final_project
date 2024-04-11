#!/bin/bash
sudo dnf install pip -y
sudo dnf -y install amazon-efs-utils
sudo dnf -y install mariadb105
sudo pip install --upgrade pip
sudo pip install flask gunicorn flask-cors requests pymysql
sudo mkdir ${mount_point}
sudo su -c  "echo '${app_efs_id}:/ ${mount_point} efs _netdev,tls 0 0' >> /etc/fstab"
sudo mount ${mount_point}
df -k