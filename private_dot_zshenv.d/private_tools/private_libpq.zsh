#!/usr/bin/env zsh
if (( ! ${+commands[psql]} )) && [[ -d "$HOMEBREW_PREFIX/opt/libpq" ]]; then
    path_append "$HOMEBREW_PREFIX/opt/libpq/bin"
fi
