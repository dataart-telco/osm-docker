HUB_REPO=datelco
COMMIT_ID=tags/v1.0.5

# get image tag from git branch/tags
get_tag=$(or $(word 2,$(subst /, ,$1)),$(value 1))
TAG=$(call get_tag,${COMMIT_ID})

build:
	docker build --build-arg COMMIT_ID=${COMMIT_ID} -t osm-so:${TAG} .
build-proxy:
	docker build --build-arg COMMIT_ID=${COMMIT_ID} --build-arg APT_PROXY=http://172.17.0.2:3142/ -t osm-so:${TAG} .
run:
	docker run --rm --name osm-so -P -it osm-so:${TAG}
run-bash:
	docker run --rm --name osm-so -P -it osm-so:${TAG} /bin/bash
push:
	docker tag osm-so:${TAG} ${HUB_REPO}/osm-so:${TAG} && docker push ${HUB_REPO}/osm-so:${TAG}
