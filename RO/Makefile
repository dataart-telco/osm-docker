build:
	docker build --build-arg COMMIT_ID=tags/v1.0.5 -t osm-ro .
build-proxy:
	docker build --build-arg COMMIT_ID=tags/v1.0.5 --build-arg http_proxy=http://172.17.0.2:3142/ -t osm-ro .
run:
	docker run --rm --name osm-ro -P -it osm-ro
push:
	docker push da-telco/osm-ro:1.0.5
