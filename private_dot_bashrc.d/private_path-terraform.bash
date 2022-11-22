# shellcheck shell=bash
if [[ -d "$HOME"/.tfenv ]]; then
    export TFENV_ROOT="$HOME"/.tfenv
fi

if [[ -d "$TFENV_ROOT"/bin ]]; then
    path_prepend "$TFENV_ROOT"/bin
    tfenv-update() {
        git --git-dir="$TFENV_ROOT"/.git pull
    }
fi

if command -v tfenv >/dev/null 2>&1; then
    eval "$(tfenv init -)"
fi
