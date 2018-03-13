FROM centos:7.4.1708

ENV container docker

# Systemd container image that would only run systemd and journald
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup", "/tmp", "/run" ]

# Install all packages
RUN \
    rpm --rebuilddb && yum clean all && \
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    yum install -y epel-release && \
    yum update -y && \
    yum install -y \
        sudo \
        initscripts \
        net-tools \
        install httpd \
        python-setuptools \
        google-chrome-stable \
        java-1.8.0-openjdk-headless \
        java-1.8.0-openjdk-devel && \
    yum clean all && \
    easy_install supervisor

# Config systemd service
COPY supervisord /

RUN systemctl enable httpd.service && \
    systemctl enable supervisord.service

# Add command and entrypoint of image
ADD command.sh /usr/local/bin/
ADD entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/command.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80 443 8080 9111

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/local/bin/command.sh"]
