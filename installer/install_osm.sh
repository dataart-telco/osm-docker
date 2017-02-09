#!/bin/bash

usage(){
    echo "Install OSM from docker containers"
    echo "usage: $0 <tag> <mtu>"
}

if [ $# -lt 1 ]; then
    usage && exit 1
fi

sudo touch /etc/default/lxd-bridge

export COMMIT_ID=$1
export HUB_REPO=datelco
export NET_MTU=${2:-1500}
export API_SERVER=`ip addr show ens3 | grep -o 'inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/.[0-9]\+' | grep -o [0-9].* | cut -d '/' -f1`
 
docker-compose -p osm -f ../docker-compose.yml up -d
