# shellcheck shell=bash
# shellcheck disable=SC1091
if [[ ! -v VIRTUAL_ENV ]]; then
    if [[ -d "$HOME/.tgenv" ]]; then
        TGENV_ROOT="$HOME/.tgenv"
        if [[ -d "$TGENV_ROOT"/bin ]]; then
            path_prepend "$TGENV_ROOT"/bin
            tgenv-update() {
                git --git-dir="$TGENV_ROOT/.git" pull
            }
        fi
    fi

    if command -v tgenv >/dev/null 2>&1; then
        eval "$(tgenv init -)"
    fi

fi
