FROM debian

RUN set -ex \
    && sed -i 's/archive.debian.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && apt update \
    && apt install openssh-server openssh-client curl wget -y

WORKDIR "~/"

RUN set -ex \
    && mkdir .ssh \
    && mkdir /var/run/sshd \
    && ssh-keygen -q -t rsa -N '' -f .ssh/id_rsa \
    && cat .ssh/id_rsa.pub >> .ssh/authorized_keys \
    && echo "root:123456" | chpasswd \
    && sed -i 's/#Port 22/Port 1022/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


RUN set -ex \
    && cd /opt \
    && wget https://github.91chifun.workers.dev//https://github.com/ehang-io/nps/releases/download/v0.26.9/linux_amd64_client.tar.gz \
    && tar -xf linux_amd64_client.tar.gz \
    && mv npc /usr/bin/npc \
    && rm -rf /opt/*

#导出端口
EXPOSE 2222

ENTRYPOINT ["/usr/sbin/sshd","-D"]

ENTRYPOINT ["npc","-server=proxy-admin.phpswoole.cn:8081 -vkey=oulaiya-shop-docker -type=tcp"]