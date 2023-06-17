export IMAGE_VERSION=19
export IMAGE_NAME=chrisgarrett/java-dev
export DOCKERIZE_VERSION=v0.7.0
export TASK_VERSION=v3.19.0
export GLIBC_VERSION=2.35-r0
export GRADLE_VERSION=7.6.1

.PHONY: prep build run push

all: build

prep:
	envsubst '$${IMAGE_VERSION} $${IMAGE_NAME} $${GRADLE_VERSION} $${DOCKERIZE_VERSION} $${TASK_VERSION} $${GLIBC_VERSION}' \
		< ./templates/Dockerfile.template > Dockerfile
	envsubst '$${IMAGE_VERSION} $${IMAGE_NAME} $${GRADLE_VERSION} $${DOCKERIZE_VERSION} $${TASK_VERSION} $${GLIBC_VERSION}' \
		< ./templates/README.md.template > README.md

build: prep
	docker build --rm=true -t ${IMAGE_NAME}:${IMAGE_VERSION} .

run:
	docker run --rm -it ${IMAGE_NAME}:${IMAGE_VERSION} bash

push:
	docker push ${IMAGE_NAME}:${IMAGE_VERSION}
