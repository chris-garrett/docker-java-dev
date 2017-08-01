FROM openjdk:8u131-jdk-alpine
MAINTAINER Chris Garrett (https://github.com/chris-garrett/docker-java-dev)
LABEL description="Java dev image 8u131"

ARG GRADLE_VERSION=3.5
ARG DOCKERIZE_VERSION=v0.5.0
COPY ./bash_aliases /home/sprout/.bashrc
COPY ./vimrc /home/sprout/.vimrc

RUN adduser -s /bin/bash -D sprout \
  && apk --no-cache add -U \
    ca-certificates \
    openssl \
  && update-ca-certificates \

  && apk --no-cache add -U \
    bash \
    vim \
    wget \
    curl \
    libstdc++ \

  && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \

  && mkdir -p /tmp/gradle \
  && cd /tmp/gradle \
  && wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
  && unzip gradle-$GRADLE_VERSION-bin.zip \
  && mkdir -p /opt \
  && mv gradle-$GRADLE_VERSION /opt/gradle-$GRADLE_VERSION \

  && chown sprout:sprout /home/sprout/.bashrc /home/sprout/.vimrc \
  && ln -sf /usr/bin/vim /usr/bin/vi \

  && rm -rf /var/cache/apk/*

  ENV GRADLE_HOME /opt/gradle-${GRADLE_VERSION}
  ENV PATH $GRADLE_HOME/bin:$PATH
  WORKDIR /work/app/src
  USER sprout
