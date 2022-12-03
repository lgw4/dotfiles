function get-info -d "Open Finder's Get Info window on a file"
    set -lx FILE (realpath $argv[1])
    if test -r "$FILE"
        osascript -e "set aFile to (POSIX file \"file:///$FILE\") as alias
                        tell application \"Finder\"
                            open information window of aFile
                            activate
                        end tell" >/dev/null 2>&1
    end
end
