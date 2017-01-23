#!/bin/bash

usage(){
    echo -e "usage: $0 [OPTIONS]"
    echo -e "Install OSM from docker containers"
    echo -e "  OPTIONS"
    echo -e "    -i: install python, docker and docker-compose"
    echo -e "    -t: osm version (tag)"
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

if [ $# -lt 1 ]; then
    usage && exit 1
fi

while getopts "iht:" o; do
    case "${o}" in
        h)
            usage && exit 0
            ;;
        i)
            install_docker && exit 0
            ;;
        t)
            sudo touch /etc/default/lxd-bridge
            # run environment
            export COMMIT_ID=$OPTARG
            export HUB_REPO=datelco
            docker-compose -f ../docker-compose.yml up -d && exit 0
            ;;
        *)
            usage && exit 1
            ;;
    esac
done