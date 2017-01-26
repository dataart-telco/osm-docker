HUB_REPO:=datelco
COMMIT_ID:=tags/v1.0.5
APT_PROXY_IP:=172.17.0.2
NO_CACHE:=false

# get image tag from git branch/tags
get_tag=$(or $(word 2,$(subst /, ,$1)),$(value 1))
TAG:=$(call get_tag,${COMMIT_ID})

config:
	sed -e 's/^from .*/from osm-so:${TAG}/' Dockerfile.tpl > Dockerfile
build: config
	docker build --no-cache=${NO_CACHE} --build-arg COMMIT_ID=${COMMIT_ID} -t osm-so-ui:${TAG} .
build-proxy: config
	docker build --no-cache=${NO_CACHE} --build-arg COMMIT_ID=${COMMIT_ID} --build-arg APT_PROXY=http://${APT_PROXY_IP}:3142/ -t osm-so-ui:${TAG} .
run:
	docker run --rm --name osm-so-ui -P -it osm-so-ui:${TAG}
run-bash:
	docker run --rm --name osm-so-ui -P -it osm-so-ui:${TAG} /bin/bash
run-test:
	docker run --rm --name osm-so-ui -p 8008:8888 -p 9443:8443 -p 4567:4567 -p 4568:4568 -it osm-so-ui:${TAG} /bin/bash
push:
	docker tag osm-so-ui:${TAG} ${HUB_REPO}/osm-so-ui:${TAG} && docker push ${HUB_REPO}/osm-so-ui:${TAG}
