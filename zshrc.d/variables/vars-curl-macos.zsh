#!/usr/bin/env zsh
if [[ "$OSTYPE" == darwin* ]]; then
    export CURL_SSL_BACKEND=secure-transport
fi
