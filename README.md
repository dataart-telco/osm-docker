Docker containers of OSM ETSI
=======

OSM ETSI - https://osm.etsi.org/ 

#### How to use

1. go to installer folder
2. install docker env - `./setup_host.sh --no-proxy`. also you can specify MTU of your network - `./setup_host.sh -m 1400 --no-proxy`
3. start containers - `./install_osm.sh v1.1`. also you can specify MTU of your network - `./install_osm.sh v1.1 1400`

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
4. make run-bash - run /bin/bash instead CMD
5. make push - push to docker hub (use `HUB_REPO` to override default)

#### Known issues:

0. VCA and UI has port conflict: 8443 is used by LXD on host. Seems this port is hardcoded in UI JS 
1. Huge size of SO and SO-UI containers
2. VCA is not finished yet. Juju uses lxd, but docker can't start it inside. **Temporary solution:** attach lxd from host to container

#### Planned actions:
1. Create configuration script: add tenant to RO, configure SO-UI 
