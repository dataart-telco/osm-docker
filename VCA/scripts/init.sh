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

#TODO check tools is already inited
#TODO possible usage - juju show-controller osm

if [ -f /root/.local/share/juju/controllers.yaml ]; then
  echo "juju is already inited"
  start_containers
else
  /opt/devops/jenkins/VCA/start_build
fi


trap stop_containers SIGHUP SIGINT SIGTERM

#TODO while read?
echo "Wait for KILL signal"
read
