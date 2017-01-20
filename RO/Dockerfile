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

RUN apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -fqy --no-install-recommends \
  software-properties-common \
  git \
  make \
  python \
  sudo \
  curl \
  wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# lsb_release stub
RUN echo 'if [ "$1" == "-is" ]; then echo "Ubuntu"; else if [ "$1" == "-rs" ]; then echo "16.04"; fi fi' > /usr/bin/lsb_release && chmod +x /usr/bin/lsb_release

# script uses it
ENV USER=root

# build variable
ARG COMMIT_ID=tags/v1.0.5

# install; disable tests
RUN git clone https://osm.etsi.org/gerrit/osm/devops.git /opt/devops && \
    sed -e '/basictest.sh/ s/^#*/#/' -i /opt/devops/jenkins/RO/start_build

# build openmano; clean
RUN /opt/devops/jenkins/RO/start_build $COMMIT_ID && \
    /RO/scripts/install-openmano-service.sh -f /RO && \
    rm -rf /opt/devops && \
    rm -rf /RO && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /opt/openmano/logs
EXPOSE 9090

CMD service mysql start && /opt/openmano/openmanod.py -c /opt/openmano/openmanod.cfg --log-file=/opt/openmano/logs/openmano.log
