Docker containers of OSM ETSI
=======

OSM ETSI - https://osm.etsi.org/ 


There are 4 containers:

1. RO - resouse orchestration: opnemano (size ~1.1G)
2. SO - service orchestration (size ~6.6G)
3. SO-UI - SO + user interface (size ~8.5G)
4. VCA - configuration agent: juju (size ~500M)

Also you can find `docker-compose` budle

#### Known issues:

1. Huge size of SO and SO-UI containers
2. VCA is not finished yet. Juju uses lxd, but docker can't start it inside. **Temporary solution:** attach lxd from host to container

#### Planned actions:
1. Create configuration script: add tenant to RO, configure SO-UI 
