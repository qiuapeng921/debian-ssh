FROM debian

RUN set -ex \
    && sed -i 's/archive.debian.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && apt update \
    && apt install openssh-server openssh-client vim sudo -y

WORKDIR /root

RUN set -ex \
    && mkdir .ssh \
    && mkdir /var/run/sshd \
    && ssh-keygen -q -t rsa -N '' -f .ssh/id_rsa \
    && cat .ssh/id_rsa.pub >> .ssh/authorized_keys \
    && echo "root:123456" | chpasswd \
    && sed -i 's/#Port 22/Port 1022/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && echo alias ll='ls -la' >> .bashrc

EXPOSE 1022

ENTRYPOINT ["/usr/sbin/sshd","-D"]