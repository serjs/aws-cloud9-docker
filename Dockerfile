FROM ubuntu:16.04
LABEL maintaner="Sergey Bogatyrets <sbogatyrets@express42.com>"

# Install Golang
ARG GOLANG_VERSION=1.9.4

RUN apt-get update
RUN apt-get install -y wget git gcc

RUN wget -P /tmp https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go$GOLANG_VERSION.linux-amd64.tar.gz && \
    rm /tmp/go$GOLANG_VERSION.linux-amd64.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Install and configure SSH from
# https://docs.docker.com/engine/examples/running_ssh_service/
RUN apt-get install -y openssh-server && mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
# SSH login fix. Otherwise user is kicked off after login
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile && ssh-keygen -A

# Install C9 environment
RUN apt-get install -y python make curl && rm -rf /var/lib/apt/lists/*
RUN curl -L https://raw.githubusercontent.com/c9/install/master/install.sh | bash

RUN apt-get purge -y gcc make && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
ENTRYPOINT [ "bash", "/entrypoint.sh" ]