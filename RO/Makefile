HUB_REPO:=datelco
COMMIT_ID:=tags/v1.0.5
APT_PROXY_IP:=172.17.0.2
NO_CACHE:=false
# get image tag from git branch/tags
get_tag=$(or $(word 2,$(subst /, ,$1)),$(value 1))
TAG:=$(call get_tag,${COMMIT_ID})

build:
	docker build --no-cache=${NO_CACHE} --build-arg COMMIT_ID=${COMMIT_ID} -t osm-ro:${TAG} .
build-proxy:
	docker build --no-cache=${NO_CACHE} --build-arg COMMIT_ID=${COMMIT_ID} --build-arg http_proxy=http://$(APT_PROXY_IP):3142/ -t osm-ro:${TAG} .
run:
	docker run --rm --name osm-ro -P -it osm-ro:${TAG}
run-bash:
	docker run --rm --name osm-ro -P -it osm-ro:${TAG} /bin/bash
push:
	docker tag osm-ro:${TAG} ${HUB_REPO}/osm-ro:${TAG} && docker push ${HUB_REPO}/osm-ro:${TAG}
