#!/bin/bash

BASE_DIR=${PWD}/keys
mkdir -p $BASE_DIR

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.osm-ui.com" \
    -keyout ${BASE_DIR}/server.key -out ${BASE_DIR}/server.crt
