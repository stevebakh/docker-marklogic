FROM centos:centos6
MAINTAINER Steven Bakhtiari <steven.bakhtiari@bbc.co.uk>

# Proxy settings for yum... only needed when trying to build this on Reith... :/
RUN echo "proxy=http://www-cache.reith.bbc.co.uk:80" >> /etc/yum.conf

# Install MarkLogic dependencies
RUN yum -y install glibc.i686 gdb.x86_64 redhat-lsb.x86_64

# Install MarkLogic
WORKDIR /tmp
ADD MarkLogic-8.0-3.x86_64.rpm /tmp/MarkLogic-8.0-3.x86_64.rpm
RUN yum -y install /tmp/MarkLogic-8.0-3.x86_64.rpm

ENV MARKLOGIC_INSTALL_DIR /opt/MarkLogic
ENV MARKLOGIC_DATA_DIR /data
ENV MARKLOGIC_FSTYPE ext4
ENV MARKLOGIC_USER daemon
ENV MARKLOGIC_PID_FILE /var/run/MarkLogic.pid
ENV MARKLOGIC_MLCMD_PID_FILE /var/run/mlcmd.pid
ENV MARKLOGIC_UMASK 022

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/MarkLogic/mlcmd/bin
ENV LD_PRELOAD /opt/MarkLogic/lib/libjemalloc.so.1
ENV LD_LIBRARY_PATH /opt/MarkLogic/lib:/data/Lib

EXPOSE 7997 7998 7999 8000 8001 8002

# Perform some initial setup of MarkLogic
ADD init_ml.sh /tmp/init_ml.sh
RUN service MarkLogic start && /tmp/init_ml.sh

#CMD tail -f /data/Logs/ErrorLog.txt
