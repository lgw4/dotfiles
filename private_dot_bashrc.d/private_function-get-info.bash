# shellcheck shell=bash
# shellcheck disable=SC2086,SC2155
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

get-info() {
    local FILE=$(realpath "${1}")
    if [[ -r "${FILE}" ]]; then
        osascript <<EOF >/dev/null 2>&1
set aFile to (POSIX file "file:///$FILE") as alias
tell application "Finder" to open information window of aFile
EOF
    fi
}
