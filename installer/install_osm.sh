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

docker-compose -f ../docker-compose.yml config
