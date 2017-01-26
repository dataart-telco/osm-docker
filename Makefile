HUB_REPO:=datelco
COMMIT_ID:=tags/v1.0.5

# get image tag from git branch/tags
get_tag=$(or $(word 2,$(subst /, ,$1)),$(value 1))
TAG:=$(call get_tag,${COMMIT_ID})

SHELL:=/bin/bash

PUSH_OPT:=COMMIT_ID=$(COMMIT_ID) HUB_REPO=$(HUB_REPO)

build:
	APT_CACHE=`docker ps | grep eg_apt_cacher_ng | awk '{print $$1}'`; \
	if [ -z "$${APT_CACHE}" ]; then make -C cache build run; else docker start $${APT_CACHE}; fi; \
	APT_CACHE=`docker ps | grep eg_apt_cacher_ng | awk '{print $$1}'`; \
	echo "container id: $${APT_CACHE}"; \
	APT_PROXY_ADDRESS=`docker inspect $${APT_CACHE} | python -c "import sys, json; print json.load(sys.stdin)[0]['NetworkSettings']['IPAddress']"`; \
	BUILD_OPT="NO_CACHE=true APT_PROXY_IP=$${APT_PROXY_ADDRESS} COMMIT_ID=$(COMMIT_ID) HUB_REPO=$(HUB_REPO)"; \
	echo $${BUILD_OPT}; \
	$(MAKE) -C RO $${BUILD_OPT} build-proxy; \
	$(MAKE) -C VCA $${BUILD_OPT} build-proxy; \
	$(MAKE) -C SO $${BUILD_OPT} build-proxy; \
	$(MAKE) -C UI $${BUILD_OPT} build-proxy; 
push:
	$(MAKE) -C RO $(PUSH_OPT) push
	$(MAKE) -C VCA $(PUSH_OPT) push
	$(MAKE) -C SO $(PUSH_OPT) push
	$(MAKE) -C UI $(PUSH_OPT) push

