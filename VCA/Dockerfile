from ubuntu:xenial

MAINTAINER Gennadiy Dubina <gennadiy.dubina@dataat.com>

RUN echo 'path-exclude /usr/share/doc/*\n\
path-include /usr/share/doc/*/copyright\n\
path-exclude /usr/share/man/*\n\
path-exclude /usr/share/groff/*\n\
path-exclude /usr/share/info/*\n\
path-exclude /usr/share/lintian/*\n\
path-exclude /usr/share/linda/*\n'\
> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
  apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -fqy --no-install-recommends \
  ca-certificates \
  git \
  sudo \
  curl \
  lxd \
  juju && \
  git clone https://osm.etsi.org/gerrit/osm/devops.git /opt/devops && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

COPY scripts /opt/init

EXPOSE 443 17070

CMD /opt/init/init.sh