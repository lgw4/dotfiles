function path_append -d "Append a directory to PATH"
    if not contains $argv $PATH
        set -x PATH $PATH $argv
    end
end
