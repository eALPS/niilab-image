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
sudo apt purge snapd -y
# tcpdumpの制限解除
sudo apt update
sudo apt install apparmor-utils -y
sudo aa-complain /usr/sbin/tcpdump
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
<<<<<<< HEAD

=======
>>>>>>> 83f2b0886b3d38264a2b8da615e6e120c996633d
sudo mkdir -p /workspace/submission
cd /workspace
sudo git init
student_id=$(hostname | cut -d "-" -f 2)
sudo git config --global user.name ${student_id}
sudo git config --global user.email ${student_id}@shinshu-u.ac.jp
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
sudo snap remove lxd
sudo snap remove core18
sudo snap remove snapd
sudo apt purge snapd -y

# tcpdumpの制限解除
sudo apt update
sudo apt install apparmor-utils -y
sudo aa-complain /usr/sbin/tcpdump