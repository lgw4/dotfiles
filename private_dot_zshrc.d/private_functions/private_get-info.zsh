get-info() {
    local file="${1:A}"
    if [[ -r "${file}" ]]; then
        osascript <<EOF >/dev/null 2>&1
set aFile to (POSIX file "file:///$file") as alias
tell application "Finder" to open information window of aFile
EOF
    fi
}
