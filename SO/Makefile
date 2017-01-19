build:
	docker build --build-arg COMMIT_ID=tags/v1.0.5 -t osm-so .
build-proxy:
	docker build --build-arg COMMIT_ID=tags/v1.0.5 --build-arg APT_PROXY=http://172.17.0.2:3142/ -t osm-so .
run:
	docker run --rm --privileged=true --name osm-so -P -it osm-so /bin/bash

