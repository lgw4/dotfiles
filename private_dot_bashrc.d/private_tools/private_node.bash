# shellcheck shell=bash
if [[ -d "$HOMEBREW_PREFIX/share/npm/bin" ]]; then
    path_append "$HOMEBREW_PREFIX/share/npm/bin"
fi

if [[ -d "$HOME/.nodenv" ]]; then
    export NODENV_ROOT="$HOME/.nodenv"
fi

if [[ -v NODENV_ROOT ]] && [[ -d "$NODENV_ROOT/bin" ]]; then
    path_prepend "$NODENV_ROOT/bin"
fi

if command -v nodenv >/dev/null 2>&1; then
    eval "$(nodenv init -)"
fi
