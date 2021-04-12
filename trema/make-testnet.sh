#!/bin/sh
cd `dirname $0`
. ./vcommon.sh

del() {
    deleteVSwitch "vswitch1"
    deleteDockerHost "vhost1" "vhost2"
}

add() {
    addOFSwitch "vswitch1" "0x1"

    addDockerHost "vhost1"
    connectVSwitchToDockerHost "vswitch1" "vhost1" "eth0" "192.168.100.10/24" "192.168.100.1"

    addDockerHost "vhost2"
    connectVSwitchToDockerHost "vswitch1" "vhost2" "eth0" "192.168.100.20/24" "192.168.100.1"
}

case "$1" in
add)
    add
    ;;
del)
    del > /dev/null 2>&1
    ;;
*)
    echo "usage: $0 { add | del }"
esac