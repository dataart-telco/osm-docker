#!/bin/bash

stop_containers() {
  echo "Stop all juju lxc containers:"
  lxc list | grep juju | awk '{print $2}' | xargs lxc stop
  echo "exit from Docker container"
  exit
}

start_containers() {
  echo "Start all juju lxc containers:"
  lxc list | grep juju | awk '{print $2}' | xargs lxc start
}

delete_all() {
  echo "Delete all containers"
  lxc list | grep juju | awk '{print $2}' | xargs lxc delete -f
}

init_juju() {
  lxd init --auto
  lxd waitready
  systemctl stop lxd-bridge
  systemctl --system daemon-reload
  cat <<EOF > /etc/default/lxd-bridge
USE_LXD_BRIDGE="true"
LXD_BRIDGE="lxdbr0"
UPDATE_PROFILE="true"
LXD_CONFILE=""
LXD_DOMAIN="lxd"
LXD_IPV4_ADDR="10.44.127.1"
LXD_IPV4_NETMASK="255.255.255.0"
LXD_IPV4_NETWORK="10.44.127.1/24"
LXD_IPV4_DHCP_RANGE="10.44.127.2,10.44.127.254"
LXD_IPV4_DHCP_MAX="252"
LXD_IPV4_NAT="true"
LXD_IPV6_ADDR=""
LXD_IPV6_MASK=""
LXD_IPV6_NETWORK=""
LXD_IPV6_NAT="false"
LXD_IPV6_PROXY="false"
EOF

  systemctl enable lxd-bridge
  systemctl start lxd-bridge
  lxc image copy ubuntu:16.04 local: --alias ubuntu-xenial
  juju bootstrap localhost osm
  juju gui --no-browser
}

#TODO check tools is already inited
#TODO possible usage - juju show-controller osm

if [ -f /root/.local/share/juju/controllers.yaml ]; then
  echo "juju is already inited"
  start_containers
else
  init_juju
fi


trap stop_containers SIGHUP SIGINT SIGTERM

#TODO while read?
echo "Wait for KILL signal"
read
