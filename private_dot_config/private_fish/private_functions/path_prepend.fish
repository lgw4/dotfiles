function path_prepend -d "Prepend a directory to PATH"
    if not contains $argv $PATH
        set -x PATH $argv $PATH
    end
end
