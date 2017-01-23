from osm-so

MAINTAINER Gennadiy Dubina <gennadiy.dubina@dataat.com>

# apt local proxy 
ARG APT_PROXY

# build variable
ARG COMMIT_ID=master

COPY patches /opt/devops-patches

RUN if [ -n "${APT_PROXY}" ]; then echo "Acquire::http { Proxy \"${APT_PROXY}\"; };" > /etc/apt/apt.conf.d/01proxy; fi && \
  apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -fqy \
  software-properties-common \
  git \
  curl \
  wget \
  rsync && \
  git clone https://osm.etsi.org/gerrit/osm/devops.git /opt/devops && \
  cd /opt/devops && git apply /opt/devops-patches/devops-ui.patch && cd / && \
  /opt/devops/jenkins/UI/start_build checkout $COMMIT_ID && \
  rm -rf /opt/devops-patches && \
  rm -rf /opt/devops && \
  rm -rf /UI && \
  rm -rf /usr/rift/usr/include/* && \
  rm -rf /usr/include/* && \
  rm /etc/apt/apt.conf.d/01proxy || true && \
  rm -rf /root/.cache && \
  apt purge -y wget curl git && \
  apt autoremove -y && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 8000 8443

#CMD is defined in parent