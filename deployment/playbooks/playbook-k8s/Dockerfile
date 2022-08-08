FROM python:3.9-slim
ENV PYTHONPATH="/usr/lib/python3/dist-packages"
RUN set -x \
    && sed -i 's/deb.debian.org/mirrors.huaweicloud.com/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install apt-transport-https ca-certificates curl gnupg sshpass python3-apt \
    && mkdir ~/.pip \
    && echo "[global]\n \
index-url = https://repo.huaweicloud.com/repository/pypi/simple\n \
trusted-host = repo.huaweicloud.com\n \
timeout = 120" > ~/.pip/pip.conf \
    && pip3 install ansible==2.10.7 kubernetes==23.3.0\
    && ansible-galaxy collection install kubernetes.core:=2.2.0 \
    && echo "deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main"  > /etc/apt/sources.list.d/kubernetes.list \
    && curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update \
    && apt-get -y remove curl \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
CMD ["/bin/bash"]
