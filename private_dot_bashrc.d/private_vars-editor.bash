# shellcheck shell=bash
if command -v code >/dev/null 2>&1 && [[ ! -v SSH_CONNECTION ]]; then
    export EDITOR="code"
else
    export EDITOR="vim"
fi
