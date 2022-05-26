#!/usr/bin/env bash
disable-docker-intel() {
    unset DOCKER_DEFAULT_PLATFORM
}

enable-docker-intel() {
    export DOCKER_DEFAULT_PLATFORM=linux/amd64
}

