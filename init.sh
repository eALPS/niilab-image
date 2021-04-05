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


# tcpdumpの制限解除
sudo apt install apparmor-utils -y
sudo aa-complain /usr/sbin/tcpdump
