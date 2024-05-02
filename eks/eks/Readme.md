# Do not change anything!

## 실행 전 해야할 것들

### target group setting
- dev-dmz-nexus-target-group
- dev-dmz-grafana-target-group
- dev-dmz-prometheus-target-group
shared_ext_lb_network_interface_ips target regist

### eks contorller instance setting
sudo useradd prod -G wheel
sudo vim /etc/sudoers           
sudo cp -r /home/ec2-user/.ssh /home/prod/.
sudo chown prod:prod -R /home/prod