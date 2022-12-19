# shellcheck shell=bash
# macOS curl config
if [[ "$OSTYPE" == darwin* ]]; then
    export CURL_SSL_BACKEND=secure-transport
fi
