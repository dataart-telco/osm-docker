from ubuntu:xenial

MAINTAINER Gennadiy Dubina <gennadiy.dubina@dataat.com>

ARG APT_PROXY

# ssh server
ENV NOTVISIBLE "in users profile"
# script uses it
ENV USER=root
# build variable
ARG COMMIT_ID=master

# add openssh-server: https://docs.docker.com/engine/examples/running_ssh_service/

# avoid docs, add proxy, install packages
RUN echo 'path-exclude /usr/share/doc/*\n\
path-include /usr/share/doc/*/copyright\n\
path-exclude /usr/share/man/*\n\
path-exclude /usr/share/groff/*\n\
path-exclude /usr/share/info/*\n\
path-exclude /usr/share/lintian/*\n\
path-exclude /usr/share/linda/*\n'\
> /etc/dpkg/dpkg.cfg.d/01_nodoc && \
  if [ -n "${APT_PROXY}" ]; then echo "Acquire::http { Proxy \"${APT_PROXY}\"; };" > /etc/apt/apt.conf.d/01proxy; fi && \
  apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -fqy --no-install-recommends \
  software-properties-common \
  git \
  make \
  python3 \
  sudo \
  curl \
  wget \
  haproxy \
  openssh-server && \
  mkdir /var/run/sshd && \
  echo 'root:screencast' | chpasswd && \
  sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
  echo "export VISIBLE=now" >> /etc/profile && \
  echo 'if [ "$1" == "-is" ]; then echo "Ubuntu"; else if [ "$1" == "-rs" ]; then echo "16.04"; fi fi' > /usr/bin/lsb_release && chmod +x /usr/bin/lsb_release && \
  git clone https://osm.etsi.org/gerrit/osm/devops.git /opt/devops && \
  /opt/devops/jenkins/SO/start_build checkout $COMMIT_ID && \
  for f in $(find /usr/rift -type l);do cp --remove-destination $(readlink $f) $f;done && \
  pip install python-magic && \
  pip3 install python-magic && \
  rm -rf /SO && \
  rm -rf /usr/rift/modules/SO/install-symlink-workaround/usr/rift/usr/rift/mano/examples && \
  rm /usr/rift/images/*.qcow2 && \
  rm -rf /usr/rift/usr/include/* && \
  rm -rf /usr/include/* && \
  rm /etc/apt/apt.conf.d/01proxy || true && \
  rm -rf /opt/devops && \
  rm -rf /root/.cache && \
  apt purge -y wget curl git && \
  apt autoremove -y && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

COPY files /opt/haproxy

VOLUME /var/log/rift/
EXPOSE 9999 8888 4567 4568

CMD haproxy -D -f /opt/haproxy/haproxy.cfg && /usr/sbin/sshd && chown syslog:syslog /var/log/rift && /usr/rift/rift-shell -r -i /usr/rift -a /usr/rift/.artifacts -- ./demos/launchpad.py --use-xml-mode
