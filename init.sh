#!/bin/bash
# スクリプトの場所に移動
cd `dirname $0`
#実行属性付与
chmod -R +x ./module

./module/docker_install.sh
./module/openvswitch_install.sh
./module/codeserver_install.sh
./module/codeserver_setting.sh
./module/container_setting.sh
./module/trema_install.sh

# 演習ファイルの配置
sudo cp -r ./trema /workspace
sudo chmod +x /workspace/*.sh
sudo chmod +x /workspace/*.rb

# tcpdumpの制限解除
sudo apt install apparmor-utils -y
sudo aa-complain /usr/sbin/tcpdump
