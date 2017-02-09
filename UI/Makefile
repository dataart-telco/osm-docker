HUB_REPO:=datelco
COMMIT_ID:=tags/v1.0.5
APT_PROXY_IP:=172.17.0.2
NO_CACHE:=false

# get image tag from git branch/tags
get_tag=$(or $(word 2,$(subst /, ,$1)),$(value 1))
TAG:=$(call get_tag,${COMMIT_ID})

build:
	docker build --no-cache=${NO_CACHE} --build-arg COMMIT_ID=${COMMIT_ID} -t osm-ui:${TAG} .
build-proxy: build
	#docker build --no-cache=${NO_CACHE} --build-arg COMMIT_ID=${COMMIT_ID} --build-arg APT_PROXY=http://${APT_PROXY_IP}:3142/ -t osm-ui:${TAG} .
run:
	docker run --rm --name osm-ui -P -it osm-ui:${TAG}
run-bash:
	docker run --rm --name osm-ui -P -it osm-ui:${TAG} /bin/bash
run-test:
	docker run --rm --name osm-ui -p 8008:8888 -p 9443:8443 -p 4567:4567 -p 4568:4568 -it osm-ui:${TAG} /bin/bash
push:
	docker tag osm-ui:${TAG} ${HUB_REPO}/osm-ui:${TAG} && docker push ${HUB_REPO}/osm-ui:${TAG}
