# shellcheck shell=bash
if [[ ! -v VIRTUAL_ENV ]] && [[ -d "$HOME"/.cargo/bin ]]; then
    path_prepend "$HOME"/.cargo/bin PATH
fi
