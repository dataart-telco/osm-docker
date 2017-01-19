build:
	docker build -t osm-vca .
build-proxy:
	docker build --build-arg http_proxy=http://172.17.0.2:3142/ --build-arg https_proxy= -t osm-vca .
run:
	docker run --rm --privileged=true --name osm-vca -P -v /var/lib/lxd/unix.socket:/var/lib/lxd/unix.socket -it osm-vca