#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y uidmap fuse3

sudo mkdir -p /etc/systemd/system/user@.service.d
cat <<EOF | sudo tee /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=yes
EOF
sudo systemctl daemon-reload








wget -P /tmp https://github.com/rootless-containers/usernetes/releases/download/v20210201.0/usernetes-x86_64.tbz
tar xjvf /tmp/usernetes-x86_64.tbz -C /opt
rm /tmp/usernetes-x86_64.tbz
cd /opt/usernetes
echo "export XDG_RUNTIME_DIR=/opt" | tee -a ~/.bashrc
export XDG_RUNTIME_DIR=/opt
./install.sh --cri=containerd



curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
# /etc/apt/sources.listは初回起動時にリセットを食らうので、.dに入れる
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo sh -c "cat << EOF >> /etc/apt/sources.list.d/docker.list
deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
EOF"


sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo systemctl restart docker.service 

sudo curl -L "https://github.com/docker/compose/releases/download/1.28.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


