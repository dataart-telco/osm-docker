#!/bin/bash

usage(){
    echo "Install and configure software on the host"
    echo "usage: $0 [mtu]"
}

install_docker() {
    echo "Install python"
    sudo apt install -y python

    echo "Install docker"
    curl -fsSL https://test.docker.com/ | sh

    echo "Add user to docker group"
    sudo usermod -aG docker $USER

    echo "Install docker-compose"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    echo "Docker-compose version:"
    docker-compose --version

    echo "\n!!! Need to relogin !!!"
}

configure_mtu() {
    mtu=$1
    echo "Configure mtu: $mtu"
    if [ -z "$mtu" ]; then
        "MTU is empty"
        return
    fi

    sed "s/fd:\/\//fd:\/\/ --mtu $mtu/" /lib/systemd/system/docker.service
    systemctl daemon-reload
    service docker restart
}

install_docker

if [ -n "$1" ]; then
    configure_mtu $1
fi
