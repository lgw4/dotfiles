#!/usr/bin/env zsh
if [[ -d "${HOMEBREW_ROOT}/share/npm/bin" ]]; then
    path_append "${HOMEBREW_ROOT}/share/npm/bin"
fi

if [[ -d "${HOME}/.nodenv" ]]; then
    export NODENV_ROOT="${HOME}/.nodenv"
fi

if [[ -v NODENV_ROOT ]] && [[ -d "${NODENV_ROOT}/bin" ]]; then
    path_prepend "${NODENV_ROOT}/bin"
fi

if (( $+commands[nodenv] )); then
    eval "$(nodenv init -)"
fi
