from ubuntu:xenial

MAINTAINER Gennadiy Dubina <gennadiy.dubina@dataat.com>

RUN apt update && apt install -y \
  git \
  sudo \
  curl \
  lxd \
  juju

# install
RUN git clone https://osm.etsi.org/gerrit/osm/devops.git /opt/devops

COPY scripts /opt/init

CMD /opt/init/init.sh