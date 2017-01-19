from ubuntu:xenial

MAINTAINER Gennadiy Dubina <gennadiy.dubina@dataat.com>

ARG APT_PROXY

RUN if [ -n "${APT_PROXY}" ]; then echo "Acquire::http { Proxy \"${APT_PROXY}\"; };" > /etc/apt/apt.conf.d/01proxy; fi

RUN apt update && apt install -y \
  git \
  make \
  python3 \
  sudo \
  curl \
  wget \
  openssh-server

# add openssh-server: https://docs.docker.com/engine/examples/running_ssh_service/

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd 
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config 
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd 

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# lsb_release stub
RUN echo 'if [ "$1" == "-is" ]; then echo "Ubuntu"; else if [ "$1" == "-rs" ]; then echo "16.04"; fi fi' > /usr/bin/lsb_release && chmod +x /usr/bin/lsb_release

# script uses it
ENV USER=root

# build variable
ARG COMMIT_ID=tags/v1.0.5

# install
RUN git clone https://osm.etsi.org/gerrit/osm/devops.git /opt/devops

# build and clean
RUN /opt/devops/jenkins/SO/start_build $COMMIT_ID; \
    rm -rf /SO/examples; \
    rm -rf /SO/.build/examples; \
    rm -rf /usr/rift/modules/SO/install-symlink-workaround/usr/rift/usr/rift/mano/examples; \
    rm /SO/common/python/rift/mano/tosca_translator/test/data/ping_pong_csar/images/*.qcow2; \
    rm /usr/rift/images/*.qcow2; \
    rm /etc/apt/apt.conf.d/01proxy

VOLUME /var/log/rift/
EXPOSE 9999 4567 4568

CMD /usr/sbin/sshd && /usr/rift/rift-shell -r -i /usr/rift -a /usr/rift/.artifacts -- ./demos/launchpad.py --use-xml-mode
