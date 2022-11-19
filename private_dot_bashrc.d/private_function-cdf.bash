# shellcheck shell=bash
# cdf (): cd to the PATH of the front Finder window
cdf () {
    TARGET="$(osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')"
    if [[ "$TARGET" != "" ]]; then
        cd "$TARGET" && pwd
    else
        echo "Error: no Finder window found." >&2
    fi
}
