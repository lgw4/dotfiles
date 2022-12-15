# shellcheck shell=bash
if ! command -v psql >/dev/null 2>&1 && [[ -d "$HOMEBREW_BASE/opt/libpq" ]]; then
    path_append "$HOMEBREW_BASE/opt/libpq/bin"
fi
