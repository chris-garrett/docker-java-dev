FROM amazoncorretto:19-alpine
MAINTAINER Chris Garrett (https://github.com/chris-garrett/docker-java-dev)
LABEL description="Java dev image 19"

ARG DOWNLOADS=/tmp/downloads
COPY ./bash_aliases /home/sprout/.bashrc
COPY ./vimrc /home/sprout/.vimrc

RUN \
  set -x \
  && apk update \
  && apk upgrade -U \
  && apk --no-cache add -U \
    git \
    make \
    bash \
    icu-libs \
    icu-data-full \
    tzdata \
    vim \
    wget \
    curl \
    libstdc++ \
  && adduser -s /bin/bash -D sprout \
  && mkdir /work \
  && chown -R sprout:sprout /work \
  && mkdir -p $DOWNLOADS \
  # dockerize
  && curl -L -o $DOWNLOADS/dockerize-linux-amd64-v0.7.0.tar.gz https://github.com/jwilder/dockerize/releases/download/v0.7.0/dockerize-alpine-linux-amd64-v0.7.0.tar.gz \
  && tar -xf $DOWNLOADS/dockerize-linux-amd64-v0.7.0.tar.gz -C /usr/local/bin \
  # task
  && curl -L -o $DOWNLOADS/task_v3.19.0_linux_amd64.tar.gz https://github.com/go-task/task/releases/download/v3.19.0/task_linux_amd64.tar.gz \
  && tar -C /usr/local/bin -xzvf $DOWNLOADS/task_v3.19.0_linux_amd64.tar.gz \  
  # glibc
  && curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && curl -L -o $DOWNLOADS/glibc-2.35-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk \
  # broken as of 3.16. work around is: https://github.com/sgerrand/alpine-pkg-glibc/issues/185#issuecomment-1261935191
  && apk add --force-overwrite $DOWNLOADS/glibc-2.35-r0.apk \
  && apk fix --force-overwrite alpine-baselayout-data \
  # https://github.com/sgerrand/alpine-pkg-glibc/issues/181
  && mkdir -p /lib64 \
  && ln -sf /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2 \
  # cleanup manual installs
  && rm -fr $DOWNLOADS \
  # gradle
  && mkdir -p /tmp/gradle \
  && cd /tmp/gradle \
  && wget https://services.gradle.org/distributions/gradle-7.6.1-bin.zip \
  && unzip gradle-7.6.1-bin.zip \
  && mkdir -p /opt \
  && mv gradle-7.6.1 /opt/gradle-7.6.1 \
  && chown sprout:sprout /home/sprout/.bashrc /home/sprout/.vimrc \
  && ln -sf /usr/bin/vim /usr/bin/vi \           
  && rm -rf /var/cache/apk/*

  ENV GRADLE_HOME /opt/gradle-7.6.1
  ENV PATH $GRADLE_HOME/bin:$PATH
  WORKDIR /work/app
  USER sprout
