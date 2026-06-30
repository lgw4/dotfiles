function cdf -d "Change directory to that of the frontmost Finder window"
    set target (osascript \
        -e 'tell application "Finder"' \
        -e 'if (count of Finder windows) > 0 then' \
        -e 'get POSIX path of (target of front Finder window as text)' \
        -e 'else' \
        -e '""' \
        -e 'end if' \
        -e 'end tell' | string collect)
    if test -n "$target"
        cd -- "$target" && echo cd (pwd)
    else
        echo 'Error: no Finder window found.' >&2
        return 1
    end
end
