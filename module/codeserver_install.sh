#!/bin/bash
sudo apt update
sudo apt upgrade -y
curl -fsSL https://code-server.dev/install.sh | sh #-s --  --version 3.8.0
systemctl --user enable --now code-server
loginusername=`whoami`
sudo loginctl enable-linger $loginusername
mkdir -p ~/.config/code-server/
cat <<EOF | tee ~/.config/code-server/config.yaml 
bind-addr: 0.0.0.0:8080
auth: none
password: af6cf06808f6c8cf518aa68d
cert: false
EOF
systemctl --user restart --now code-server

