FROM node:7

MAINTAINER Gennadiy Dubina <gennadiy.dubina@dataat.com>

# build variable
ARG COMMIT_ID=master

COPY patches /opt/osm-patches

RUN git clone https://osm.etsi.org/gerrit/osm/UI.git /usr/src/UI && \
    cd /usr/src/UI && \
    git checkout $COMMIT_ID && \
    rm -rf /usr/src/UI/skyquake/plugins/helloworld && \
    rm -rf /usr/src/UI/skyquake/plugins/goodbyeworld && \
    git apply /opt/osm-patches/hot_fix.patch && \
    cd /usr/src/UI/skyquake && ./scripts/build.sh 

WORKDIR /usr/src/UI/skyquake

COPY scripts /opt/osm-tools

ENV API_SERVER=localhost UPLOAD_SERVER=

EXPOSE 8443

CMD /opt/osm-tools/key_gen.sh && node skyquake.js --enable-https --keyfile-path=./keys/server.key --certfile-path=./keys/server.crt --api-server=$API_SERVER --upload-server=$UPLOAD_SERVER
