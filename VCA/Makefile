HUB_REPO:=datelco
COMMIT_ID:=tags/v1.0.5
APT_PROXY_IP:=172.17.0.2
NO_CACHE:=false

# get image tag from git branch/tags
get_tag=$(or $(word 2,$(subst /, ,$1)),$(value 1))
TAG:=$(call get_tag,${COMMIT_ID})

build:
	docker build --no-cache=${NO_CACHE} -t osm-vca:${TAG} .
build-proxy:
	docker build --no-cache=${NO_CACHE} --build-arg http_proxy=http://${APT_PROXY_IP}:3142/ --build-arg https_proxy= -t osm-vca:${TAG} .
run:
	docker run --rm --privileged=true --name osm-vca -P \
	-v /var/run/dbus:/var/run/dbus \
	-v /run/systemd:/run/systemd \
	-v /usr/bin/systemctl:/usr/bin/systemctl \
	-v /etc/systemd/system:/etc/systemd/system \
	-v /var/lib/lxd/:/var/lib/lxd/ \
	-v /etc/default/lxd-bridge:/etc/default/lxd-bridge \
	-it osm-vca:${TAG}
run-bash:
	docker run --rm --privileged=true --name osm-vca -P \
	-v /var/run/dbus:/var/run/dbus \
	-v /run/systemd:/run/systemd \
	-v /usr/bin/systemctl:/usr/bin/systemctl \
	-v /etc/systemd/system:/etc/systemd/system \
	-v /var/lib/lxd/:/var/lib/lxd/ \
	-v /etc/default/lxd-bridge:/etc/default/lxd-bridge \
	-it osm-vca:${TAG} /bin/bash
run-d:
	docker run -d --privileged=true --name osm-vca -P \
	-v /var/run/dbus:/var/run/dbus \
	-v /run/systemd:/run/systemd \
	-v /usr/bin/systemctl:/usr/bin/systemctl \
	-v /etc/systemd/system:/etc/systemd/system \
	-v /var/lib/lxd/:/var/lib/lxd/ \
	-v /etc/default/lxd-bridge:/etc/default/lxd-bridge \
	-it osm-vca:${TAG}
push:
	docker tag osm-vca:${TAG} ${HUB_REPO}/osm-vca:${TAG} && docker push ${HUB_REPO}/osm-vca:${TAG}
