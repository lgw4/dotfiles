function disable-docker-intel -d "Use arm64 for Docker images"
    set -e DOCKER_DEFAULT_PLATFORM
end


function enable-docker-intel -d "Use amd64 for Docker images"
    set -x DOCKER_DEFAULT_PLATFORM=linux/amd64
end
