Docker containers of OSM ETSI
=======

OSM ETSI - https://osm.etsi.org/ 


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

1. Huge size of SO and SO-UI containers
2. VCA is not finished yet. Juju uses lxd, but docker can't start it inside. **Temporary solution:** attach lxd from host to container

#### Planned actions:
1. Create configuration script: add tenant to RO, configure SO-UI 
