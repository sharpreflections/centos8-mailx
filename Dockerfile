FROM centos:8
LABEL maintainer="dennis.brendel@sharpreflections.com"

ENV MAILRC /root/.mailrc

WORKDIR /root/

RUN yum -y upgrade && \
    yum -y install mailx openssh-clients && \
    yum clean all

COPY mailrc /root/.mailrc
COPY run.sh /root/run.sh

ENTRYPOINT ["/root/run.sh"]
