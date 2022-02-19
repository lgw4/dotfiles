# shellcheck shell=bash
disable-docker-intel() {
    unset DOCKER_DEFAULT_PLATFORMs
}

enable-docker-intel() {
    export DOCKER_DEFAULT_PLATFORM=linux/amd64
}
