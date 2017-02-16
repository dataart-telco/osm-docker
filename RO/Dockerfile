from ubuntu:xenial

MAINTAINER Gennadiy Dubina <gennadiy.dubina@dataat.com>

# script uses it
ENV USER=root

# build variable
ARG COMMIT_ID=master

COPY patches /opt/devops-patches

RUN echo 'path-exclude /usr/share/doc/*\n\
path-include /usr/share/doc/*/copyright\n\
path-exclude /usr/share/man/*\n\
path-exclude /usr/share/groff/*\n\
path-exclude /usr/share/info/*\n\
path-exclude /usr/share/lintian/*\n\
path-exclude /usr/share/linda/*\n'\
> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
    echo  'APT::Install-Recommends "false";\n\
APT::AutoRemove::RecommendsImportant "false";\n\
APT::AutoRemove::SuggestsImportant "false";\n'\
> /etc/apt/apt.conf.d/99_norecommends && \
  apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -fqy \
  software-properties-common \
  git \
  make \
  python \
  sudo \
  curl \
  wget && \
  echo 'if [ "$1" == "-is" ]; then echo "Ubuntu"; else if [ "$1" == "-rs" ]; then echo "16.04"; fi fi' > /usr/bin/lsb_release && chmod +x /usr/bin/lsb_release && \
  git clone https://osm.etsi.org/gerrit/osm/devops.git /opt/devops && \
  cd /opt/devops && git apply /opt/devops-patches/devops-ro.patch && cd / && \
  sed -e '/basictest.sh/ s/^#*/#/' -i /opt/devops/jenkins/RO/start_build && \
  /opt/devops/jenkins/RO/start_build checkout $COMMIT_ID && \
  /RO/scripts/install-openmano-service.sh -f /RO && \
  rm -rf /opt/devops-patches && \
  rm -rf /opt/devops && \
  rm -rf /RO && \
  rm -rf /usr/include/* && \
  rm -rf /root/.cache && \
  apt purge -y git curl wget python-pip && \
  apt autoremove -y && \ 
  apt clean && \
  rm -rf /var/lib/apt/lists/*

COPY scripts/ /opt/openmano-utils

VOLUME /opt/openmano/logs
EXPOSE 9090

env DB_USER='' DB_PSWD='' DB_HOST='' DB_PORT=3306 DB_NAME=mano_db

CMD /opt/openmano-utils/start.sh
