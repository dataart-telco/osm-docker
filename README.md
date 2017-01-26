Docker containers of OSM ETSI
=======

OSM ETSI - https://osm.etsi.org/ 

#### How to use

1. go to installer folder
2. install host env (python, docker, docker-compose) - `./setup_host.sh --no-proxy`. also you can specify MTU of your network - `./setup_host.sh -m 1400 --no-proxy`
3. start containers - `./install_osm.sh v1.1`. also you can specify MTU of your network - `./install_osm.sh v1.1 1400`
4. when software is started inside containers (use `docker log <container>`) configure it - `./configure.sh`

**UI** uses https with **9443**

#### Containers

There are 4 containers:

1. RO - resouse orchestration: opnemano (size 859M)
2. SO - service orchestration (size ~5.5G)
3. SO-UI - SO + user interface (size ~7.5G)
4. VCA - configuration agent: juju (size ~500M)

Also you can find `docker-compose` budle

#### Make commands

There are 2 args: `HUB_REPO=datelco` and `COMMIT_ID=tags/v1.0.5`. 
You can override them to build appropriate container

1. make build 
2. make build-proxy - use loca apt proxy
3. make run
4. make run-bash - run /bin/bash instead of CMD
5. make push - push to docker hub (use `HUB_REPO` to override default)

#### Known issues:

1. VCA uses LXC/LXD from the host. Need to stop lxc containers when we stop VCA docker container
2. UI container has own set of pathes. Need to apply them to official repo

#### Planned actions:
1. Fix issues with juju lxc containers lifecycle
