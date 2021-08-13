# shellcheck shell=bash
# Homebrew npm executables
if [[ ! -v VIRTUAL_ENV ]] && [[ -d "$HOMEBREW_ROOT"/share/npm/bin ]]; then
    path_append "$HOMEBREW_ROOT"/share/npm/bin PATH
fi

export NODENV_ROOT="$HOME/.nodenv"
if [[ -d "$NODENV_ROOT"/bin ]]; then
    path_prepend "$NODENV_ROOT"/bin
fi

if command -v nodenv >/dev/null 2>&1; then
    eval "$(nodenv init -)"
fi
