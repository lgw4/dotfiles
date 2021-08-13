#!/usr/bin/env zsh
if [[ -d "$HOME"/.cabal/bin ]]; then
    path_prepend "$HOME"/.cabal/bin
fi
