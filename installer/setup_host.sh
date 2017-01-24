#!/bin/bash

usage(){
    echo "usage: $0 [OPTIONS]"
    echo "Install and configure software on the host"
    echo "  OPTIONS"
    echo -e "    -m MTU:\t setup network mtu"
    echo -e "    --no-proxy:\t disable docker-proxy"
    echo -e "    -h, --help:\t show this help"
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

    sudo sed -i "s/dockerd/dockerd --mtu $mtu/" /lib/systemd/system/docker.service
    sudo systemctl daemon-reload
    sudo service docker restart
}

disable_docker_proxy() {
    sudo sed -i "s/dockerd/dockerd --userland-proxy=false/" /lib/systemd/system/docker.service
    sudo systemctl daemon-reload
    sudo service docker restart
}

DISABLE_PROXY=false
NET_MTU=''

while getopts ":m:h-:" o; do
    case "${o}" in
        m)
            NET_MTU="$OPTARG"
            ;;

        h)
            usage && exit 0
            ;;
        -)
            [ "${OPTARG}" == "help" ] && usage && exit 0
            [ "${OPTARG}" == "no-proxy" ] && DISABLE_PROXY=true && continue
            echo -e "Invalid option: '--$OPTARG'\nTry $0 --help for more information" >&2 
            exit 1
            ;; 
        \?)
            echo -e "Invalid option: '-$OPTARG'\nTry $0 --help for more information" >&2
            exit 1
            ;;
        :)
            echo -e "Option '-$OPTARG' requires an argument\nTry $0 --help for more information" >&2
            exit 1
            ;;
        *)
            usage >&2
            exit 1
            ;;
    esac
done

install_docker

if [ "$DISABLE_PROXY" = true ]; then
    disable_docker_proxy
fi

if [ -n "$NET_MTU" ]; then
    configure_mtu $NET_MTU
fi
