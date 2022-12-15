#!/usr/bin/env zsh
if (( ! ${+commands[psql]} )) && [[ -d "$HOMEBREW_BASE/opt/libpq" ]]; then
    path_append "$HOMEBREW_BASE/opt/libpq/bin"
fi
