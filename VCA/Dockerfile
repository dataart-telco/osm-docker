from ubuntu:xenial

MAINTAINER Gennadiy Dubina <gennadiy.dubina@dataat.com>

RUN echo 'path-exclude /usr/share/doc/*\n\
path-include /usr/share/doc/*/copyright\n\
path-exclude /usr/share/man/*\n\
path-exclude /usr/share/groff/*\n\
path-exclude /usr/share/info/*\n\
path-exclude /usr/share/lintian/*\n\
path-exclude /usr/share/linda/*\n'\
> /etc/dpkg/dpkg.cfg.d/01_nodoc

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