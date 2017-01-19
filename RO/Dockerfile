from ubuntu:xenial

MAINTAINER Gennadiy Dubina <gennadiy.dubina@dataat.com>

RUN apt update && apt install -y \
  git \
  make \
  python \
  sudo \
  curl \
  wget

# lsb_release stub
RUN echo 'if [ "$1" == "-is" ]; then echo "Ubuntu"; else if [ "$1" == "-rs" ]; then echo "16.04"; fi fi' > /usr/bin/lsb_release && chmod +x /usr/bin/lsb_release

# script uses it
ENV USER=root

# build variable
ARG COMMIT_ID=tags/v1.0.5

# install
RUN git clone https://osm.etsi.org/gerrit/osm/devops.git /opt/devops

# disable tests
RUN sed -e '/basictest.sh/ s/^#*/#/' -i /opt/devops/jenkins/RO/start_build

# build openmano
RUN /opt/devops/jenkins/RO/start_build $COMMIT_ID
RUN /RO/scripts/install-openmano-service.sh -f /RO

# cleanup
RUN rm -rf /opt/devops && rm -rf /RO && rm -rf /var/lib/apt/lists/*

VOLUME /opt/openmano/logs
EXPOSE 9090

CMD service mysql start && /opt/openmano/openmanod.py -c /opt/openmano/openmanod.cfg --log-file=/opt/openmano/logs/openmano.log
