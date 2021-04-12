deleteDockerHost() {
   local host
   for host in "$@"; do
       docker stop "$host"
       docker rm "$host"
   done
}

deleteVSwitch() {
   local switch
   for switch in "$@"; do
       sudo ovs-vsctl del-br "$switch"
   done
}

deleteVLink() {
   local link
   for link in "$@"; do
       sudo ip link delete "$link"
       sudo ip link delete "${link}-0"
       sudo ip link delete "${link}-1"
   done
}

addDockerHost() {
    local host="$1"
    cd `dirname $0`
    docker build -f ./Dockerfile -t vhost/alpine .
    docker run -itd --name $host -h $host --net=none vhost/alpine
}

addVSwitch() {
    local switch="$1"
    sudo ovs-vsctl add-br "$switch"
}

setupVSwitchAsOpenFlowSwitch() {
    local switch="$1"
    local datapath_id="$2"

    if [ "$datapath_id" != "" ]; then
        sudo ovs-vsctl set bridge "$switch" other-config:datapath-id=`printf \"%016x\" $datapath_id`
        sudo ovs-vsctl set bridge "$switch" protocols=OpenFlow10
    fi
    sudo ovs-vsctl set-fail-mode "$switch" secure
    sudo ovs-vsctl set-controller "$switch" tcp:127.0.0.1:6653 -- \
        set controller "$switch" connection-mode=out-of-band -- \
        set controller "$switch" inactivity-probe=180 -- \
        set controller "$switch" controller-rate-limit=40000 -- \
        set controller "$switch" controller-burst-limit=20000
}

addOFSwitch() {
    addVSwitch "$1"
    setupVSwitchAsOpenFlowSwitch "$1" "$2"
}

connectVSwitchToVSwitch() {
    local switch1="$1"
    local link="$2"
    local switch2="$3"

    sudo ip link add name "${link}-0" type veth peer name "${link}-1"

    sudo ip link set "${link}-0" up
    sudo ovs-vsctl add-port "$switch1" "${link}-0"

    sudo ip link set "${link}-1" up
    sudo ovs-vsctl add-port "$switch2" "${link}-1"
}

connectVHostToVSwitch() {
    local host="$1"
    local link="$2"
    local switch="$3"
    local opt="$4"

    sudo ip link add name "${link}" type veth peer name "${link}-1"

    sudo ip link set "${link}-1" netns "$host"
    sudo ip netns exec "$host" ip link set "${link}-1" name "${link}"
    sudo ip netns exec "$host" ifconfig "${link}" up

    sudo ip link set "${link}" up
    sudo ovs-vsctl add-port "$switch" "${link}" $opt
}

connectVSwitchToDockerHost() {
    local switch="$1"
    local host="$2"
    local nic="$3"
    local ip="$4"
        local gw="$5"

    if [ -n "$gw" ]; then
        ovs-docker add-port $switch $nic $host --ipaddress=$ip --gateway=$gw
    else
        ovs-docker add-port $switch $nic $host --ipaddress=$ip
    fi

}

createVLink() {
    local link="$1"
    sudo ip link add name "${link}-0" type veth peer name "${link}-1"
}

connectVLinkSide0ToVSwitch() {
    local link="$1"
    local switch="$2"

    sudo ip link set "${link}-0" up
    sudo ovs-vsctl add-port "$switch" "${link}-0"
}


connectVLinkSide1ToVSwitch() {
    local link="$1"
    local switch="$2"

    sudo ip link set "${link}-1" up
    sudo ovs-vsctl add-port "$switch" "${link}-1"
}

vhostExec() {
    sudo ip netns exec "$@"
}