function path_remove -d "Remove a directory from PATH"
    if contains $argv $PATH
        set -x PATH (string match -v $argv $PATH)
    end
end
