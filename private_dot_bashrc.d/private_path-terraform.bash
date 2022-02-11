# shellcheck shell=bash
# shellcheck disable=SC1091
if [[ ! -v VIRTUAL_ENV ]]; then
    if [[ -d "$HOME/.tfenv" ]]; then
        TFENV_ROOT="$HOME/.tfenv"
        if [[ -d "$TFENV_ROOT"/bin ]]; then
            path_prepend "$TFENV_ROOT"/bin
            tfenv-update() {
                git --git-dir="$TFENV_ROOT/.git" pull
            }
        fi
    fi

    if command -v tfenv >/dev/null 2>&1; then
        eval "$(tfenv init -)"
    fi

fi
