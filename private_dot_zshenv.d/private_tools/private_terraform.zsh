#!/usr/bin/env zsh
if [[ -d "$HOME/.tfenv" ]]; then
    export TFENV_ROOT="$HOME/.tfenv"
fi

if [[ -v TFENV_ROOT ]] && [[ -d "$TFENV_ROOT/bin" ]]; then
    path_prepend "$TFENV_ROOT/bin"
    tfenv-update () {
        git --git-dir="$TFENV_ROOT/.git pull"
    }
fi

if (( ${+commands[tfenv]} )); then
    eval "$(tfenv init -)"
fi
