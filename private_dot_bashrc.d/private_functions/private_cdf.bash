# shellcheck shell=bash
# cdf (): cd to the PATH of the front Finder window
cdf () {
    target="$(osascript \
        -e 'tell application "Finder"' \
        -e 'if (count of Finder windows) > 0 then' \
        -e 'get POSIX path of (target of front Finder window as text)' \
        -e 'else' \
        -e '""' \
        -e 'end if' \
        -e 'end tell')"
    if [[ -n "${target}" ]]; then
        cd -- "${target}" && pwd
    else
        echo "Error: no Finder window found." >&2
        return 1
    fi
}
