# shellcheck shell=bash
# shellcheck disable=SC2103,SC2155,SC2164
if [[ -d "$HOME/.tfenv" ]]; then
    export TFENV_ROOT="$HOME/.tfenv"
fi

if [[ -v TFENV_ROOT ]] && [[ -d "$TFENV_ROOT/bin" ]]; then
    path_prepend "$TFENV_ROOT/bin"
    tfenv-update () {
        local current_directory=$(pwd)
        cd "$TFENV_ROOT"
        git fetch
        git pull
        cd "$current_directory"
        unset current_directory
    }
fi

if command -v tfenv >/dev/null 2>&1; then
    eval "$(tfenv init -)"
fi
