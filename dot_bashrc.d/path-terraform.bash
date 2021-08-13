# shellcheck shell=bash
# shellcheck disable=SC1091
if [[ ! -v VIRTUAL_ENV ]]; then
    export TFENV_ROOT="$HOME/.tfenv"
    if [[ -d "$TFENV_ROOT"/bin ]]; then
        path_prepend "$TFENV_ROOT"/bin
    fi

    if command -v tfenv >/dev/null 2>&1; then
        eval "$(tfenv init -)"
    fi

    tfenv_update() {
        cd "$TFENV_ROOT" || exit
        git fetch
        git pull origin master
        cd "$HOME" || exit
    }
fi
