#!/bin/bash
# スクリプトの場所に移動
cd `dirname $0`
#実行属性付与
chmod -R +x ./module

./module/docker_install.sh

./module/openvswitch_install.sh

./module/codeserver_install.sh

./module/codeserver_setting.sh

./module/host_setting.sh





#lxdをインストールする
sudo apt install  zfsutils-linux -y
sudo snap install lxd
sudo snap install lxd --channel=latest/stable
sudo snap refresh lxd --channel=latest/stable
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=3010:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor
docker run -d --name=grafana -p 3020:3000 grafana/grafana
sudo apt install 
sudo apt install prometheus -y
#  - job_name: cadvisor
#    # metrics_path defaults to '/metrics'
#    # scheme defaults to 'http'.
#    static_configs:
#      - targets: ['localhost:3010']


# lxd init
# ストレージとかを設定する
#lxc profile set  default  security.nesting "true"
#

