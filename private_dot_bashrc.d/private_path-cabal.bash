# shellcheck shell=bash
if [[ ! -v VIRTUAL_ENV ]] && [[ -d "$HOME"/.cabal/bin ]]; then
    path_prepend "$HOME"/.cabal/bin PATH
fi
