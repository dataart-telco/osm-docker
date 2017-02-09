#!/bin/bash

BASE_DIR=${PWD}/keys
mkdir -p $BASE_DIR

cp  /opt/osm-tools/current.cert ${BASE_DIR}/server.crt
cp /opt/osm-tools/current.key ${BASE_DIR}/server.key

#openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
#    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.osm-ui.com" \
#    -keyout ${BASE_DIR}/server.key -out ${BASE_DIR}/server.crt
