# shellcheck shell=bash
if [[ -d "$HOME"/.local/bin ]]; then
    path_prepend "$HOME"/.local/bin
fi
