#!/usr/bin/env zsh
if (( $+commands[code-insiders] )) && [[ ! -v SSH_CONNECTION ]]; then
    export EDITOR="code-insiders"
elif (( $+commands[code] )) && [[ ! -v SSH_CONNECTION ]]; then
    export EDITOR="code"
else
    export EDITOR="vim"
fi
