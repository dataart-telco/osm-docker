from osm-so

MAINTAINER Gennadiy Dubina <gennadiy.dubina@dataat.com>

ARG APT_PROXY

RUN if [ -n "${APT_PROXY}" ]; then echo "Acquire::http { Proxy \"${APT_PROXY}\"; };" > /etc/apt/apt.conf.d/01proxy; fi

# build variable
ARG COMMIT_ID=tags/v1.0.5

# build and clean
RUN /opt/devops/jenkins/UI/start_build $COMMIT_ID; \
    rm -rf /opt/devops; \
    rm -rf /UI; \
    rm /etc/apt/apt.conf.d/01proxy; \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8888 8000 8443

CMD /usr/sbin/sshd && /usr/rift/rift-shell -r -i /usr/rift -a /usr/rift/.artifacts -- ./demos/launchpad.py --use-xml-mode