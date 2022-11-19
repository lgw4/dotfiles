# shellcheck shell=bash
if ! command -v psql >/dev/null 2>&1 && [[ -d "$HOMEBREW_ROOT"/opt/libpq ]]; then
    path_append "$HOMEBREW_ROOT"/opt/libpq/bin
fi
