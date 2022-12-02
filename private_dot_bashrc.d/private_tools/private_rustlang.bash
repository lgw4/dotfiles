# shellcheck shell=bash
if [[ -d "$HOME/.cargo/bin" ]]; then
    path_prepend "$HOME/.cargo/bin"
fi
