#!/bin/bash

# tcpdumpの制限解除
sudo apt install apparmor-utils -y


#カーネルリミッター解除
sudo sh -c "cat << EOF >> /etc/security/limits.conf
*       soft    nofile  1048576
*       hard    nofile  1048576
root    soft    nofile  1048576
root    hard    nofile  1048576
*       soft    memlock unlimited
*       hard    memlock unlimited
root       soft    memlock unlimited
root       hard    memlock unlimited
EOF"

sudo sh -c "cat << EOF >> /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding=1
fs.inotify.max_queued_events=1048576
fs.inotify.max_user_instances=1048576
fs.inotify.max_user_watches=1048576
vm.max_map_count=262144
kernel.dmesg_restrict=1
net.ipv4.neigh.default.gc_thresh3=8192
net.ipv6.neigh.default.gc_thresh3=8192
net.core.bpf_jit_limit=3000000000
kernel.keys.maxkeys=5000
kernel.keys.maxbytes=2000000
fs.aio-max-nr=524288
net.core.netdev_max_backlog = 182757
kernel.unprivileged_userns_clone = 1
EOF"


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
sudo sysctl -p
iptables -P FORWARD ACCEPT
iptables -A FORWARD -p all -i br0 -j ACCEPT
sudo aa-complain /usr/sbin/tcpdump
EOF
sudo chmod +x /usr/local/bin/startup.sh
sudo systemctl daemon-reload 
sudo systemctl enable startup.service 
sudo systemctl start startup.service
