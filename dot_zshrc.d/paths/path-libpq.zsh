#!/usr/bin/env zsh
if ! (( $+commands[psql] )) && [[ -d "$HOMEBREW_ROOT"/opt/libpq ]]; then
    path_append "$HOMEBREW_ROOT"/opt/libpq/bin
fi
