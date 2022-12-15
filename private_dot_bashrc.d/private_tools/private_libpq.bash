# shellcheck shell=bash
if ! command -v psql >/dev/null 2>&1 && [[ -d "$HOMEBREW_PREFIX/opt/libpq" ]]; then
    path_append "$HOMEBREW_PREFIX/opt/libpq/bin"
fi
