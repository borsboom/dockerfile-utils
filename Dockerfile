FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
        curl \
        dnsutils \
        gcc \
        git \
        groff \
        iputils-ping \
        iputils-tracepath \
        libdigest-hmac-perl \
        libfile-libmagic-perl \
        libio-socket-inet6-perl \
        libio-socket-ssl-perl \
        libmime-lite-perl \
        libnet-dns-perl \
        libterm-readkey-perl \
        nano \
        netcat \
        postgresql-client-10 \
        socat \
        sudo \
        telnet \
        traceroute \
        unzip \
        vim \
        wget \
        mysql-client-5.7 \
        && \
    rm -rf /var/lib/apt/lists/*
COPY core_dump.c stack_smash.c /tmp/
RUN gcc -o /usr/local/bin/stack_smash -fstack-protector -g -O0 -std=c99  /tmp/stack_smash.c && \
    rm /tmp/stack_smash.c && \
    gcc -o /usr/local/bin/core_dump /tmp/core_dump.c && \
    rm /tmp/core_dump.c
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.9/bin/linux/amd64/kubectl && \
    chmod a+x kubectl && \
    cp kubectl /usr/local/bin/kubectl
RUN cd /tmp && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.8/argocd-linux-amd64 && \
    chmod +x /usr/local/bin/argocd
RUN curl -sSL -o /usr/local/bin/smtp-cli "https://raw.githubusercontent.com/mludvig/smtp-cli/master/smtp-cli" && \
    chmod a+x /usr/local/bin/smtp-cli
