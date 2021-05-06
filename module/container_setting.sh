#!/bin/bash
#スタートアップスクリプト
cat <<EOF | sudo tee /etc/systemd/system/startup.service 
[Unit]
Description= startup
After=multi-user.target
Before=shutdown.target
[Service]
ExecStart = /usr/local/bin/startup.sh
Restart = no
Type = simple
RemainAfterExit=yes

[Install]
WantedBy = multi-user.target
EOF

cat <<EOF | sudo tee /usr/local/bin/startup.sh
#!/bin/bash
iptables -P FORWARD ACCEPT
sudo aa-complain /usr/sbin/tcpdump
EOF
sudo chmod +x /usr/local/bin/startup.sh
sudo systemctl daemon-reload 
sudo systemctl enable startup.service 
sudo systemctl start startup.service

#eth1設定追加
cat <<EOF | sudo tee  /etc/netplan/00-niilab.yaml 
network:
    version: 2
    ethernets:
        eth0:
            dhcp4: true
        eth1:
            dhcp4: true
            dhcp4-overrides:
                use-routes: false
EOF
sudo netplan apply

sudo apt purge snapd -y

# tcpdumpの制限解除
sudo apt install apparmor-utils -y
sudo aa-complain /usr/sbin/tcpdump