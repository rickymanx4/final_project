#!/bin/bash
sudo dnf install nginx -y
sudo systemctl enable --now nginx
sudo mkdir -p /etc/pki/nginx/private
