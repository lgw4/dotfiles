function __goenv_completions
    set -l cmd (commandline -opc)

    if test (count $cmd) -gt 0
        set cmd $cmd[2..-1]
    end

    if test (count $cmd) -eq 0
        goenv commands 2>/dev/null
    else
        goenv completions $cmd 2>/dev/null
    end
end

complete -c goenv -f -a '(__goenv_completions)'
