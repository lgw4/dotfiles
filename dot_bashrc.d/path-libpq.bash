# shellcheck shell=bash
if ! command -v psql >/dev/null 2>&1 && [[ -d "${HOMEBREW_ROOT}/opt/libpq" ]]; then
    # export CPPFLAGS="-I${HOMEBREW_ROOT}/opt/libpq/include ${CPPFLAGS}"
    # export LDFLAGS="-L${HOMEBREW_ROOT}/opt/libpq/lib ${LDFLAGS}"
    path_append "${HOMEBREW_ROOT}/opt/libpq/bin" PATH
fi
