FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        curl \
        docker.io \
        dnsutils \
        gcc \
        git \
        groff \
        iputils-ping \
        iputils-tracepath \
        jq \
        libdigest-hmac-perl \
        libfile-libmagic-perl \
        libio-socket-inet6-perl \
        libio-socket-ssl-perl \
        libmime-lite-perl \
        libnet-dns-perl \
        libterm-readkey-perl \
        mariadb-client-10.6 \
        nano \
        netcat \
        openssh-server \
        postgresql-client-14 \
        python3 \
        python3-venv \
        ripgrep \
        screen \
        socat \
        sudo \
        telnet \
        traceroute \
        unzip \
        vim \
        wget \
        && \
    rm -rf /var/lib/apt/lists/*
# ubuntu 18.04: mysql-client-5.7 postgresql-client-10

COPY core_dump.c stack_smash.c /tmp/
RUN gcc -o /usr/local/bin/stack_smash -fstack-protector -g -O0 -std=c99  /tmp/stack_smash.c && \
    rm /tmp/stack_smash.c && \
    gcc -o /usr/local/bin/core_dump /tmp/core_dump.c && \
    rm /tmp/core_dump.c

RUN curl -sSLfo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.24.8/bin/linux/amd64/kubectl && \
    chmod a+x /usr/local/bin/kubectl

RUN cd /tmp && \
    curl -sSLfo "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

RUN curl -sSLf "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash -s 5.2.1 && \
    mv kustomize /usr/local/bin

RUN curl -sSLfo /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.15/argocd-linux-amd64 && \
    chmod +x /usr/local/bin/argocd

RUN curl -sSLfo /usr/local/bin/smtp-cli "https://raw.githubusercontent.com/mludvig/smtp-cli/master/smtp-cli" && \
    chmod a+x /usr/local/bin/smtp-cli

RUN curl -sSLf https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN curl -sSLf --http1.1 https://cnfl.io/cli | sh -s -- -b /usr/local/bin latest

RUN curl -sSLfo /usr/local/bin/tini https://github.com/krallin/tini/releases/download/v0.19.0/tini && \
    chmod a+x /usr/local/bin/tini
ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/bin/bash"]

ENV PATH=/opt/tfenv/bin:$PATH
RUN git clone https://github.com/tfutils/tfenv.git /opt/tfenv && \
    echo 'export PATH="/opt/tfenv/bin:$PATH"' >/etc/profile.d/tfenv.sh && \
    echo 'export TFENV_CONFIG_DIR="$HOME/.tfenv"' >>/etc/profile.d/tfenv.sh

RUN echo '%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' >/etc/sudoers.d/sudo-group-nopasswd

RUN touch /etc/skel/.hushlogin

RUN curl -sS https://starship.rs/install.sh | sudo sh -s -- -y && \
    echo 'eval "$(starship init bash)"' >>/etc/skel/.bashrc

RUN curl -sSLo /usr/local/bin/aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64 && \
    chmod a+x /usr/local/bin/aws-iam-authenticator

RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

RUN curl -sSL https://github.com/mikefarah/yq/releases/download/v4.33.3/yq_linux_amd64.tar.gz | tar xzf - && \
    mv yq_linux_amd64 /usr/local/bin/yq

RUN curl -sSL https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.20.5/kubeseal-0.20.5-linux-amd64.tar.gz |tar xzf - kubeseal && \
    mv kubeseal /usr/local/bin/kubeseal

RUN echo 'if which code 2>&1 >/dev/null; then export EDITOR="code -w"; fi' >>/etc/skel/.profile

COPY gitconfig /etc/skel/.gitconfig
