#!/usr/bin/env zsh
get-info() {
    local FILE="{$1:A}"
    if [[ -r "${FILE}" ]]; then
        osascript <<EOF >/dev/null 2>&1
set aFile to (POSIX file "file:///$FILE") as alias
tell application "Finder" to open information window of aFile
EOF
    fi
}
