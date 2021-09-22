#!/bin/bash
sudo apt update
sudo apt upgrade -y
curl -fsSL https://code-server.dev/install.sh | sh -s --  --version 3.9.3
mkdir -p ~/.config/code-server/
cat <<EOF | tee ~/.config/code-server/config.yaml 
bind-addr: 0.0.0.0:8080
auth: none
password: af6cf06808f6c8cf518aa68d
cert: false
EOF
#自動起動設定
cat <<EOF | sudo tee /etc/systemd/system/code-server.service 
[Unit]
Description=code-server
After=network.target

[Service]
Type=exec
ExecStart=/usr/bin/code-server
Restart=always

[Install]
WantedBy=default.target
EOF
systemctl  enable --now code-server
systemctl  restart --now code-server


