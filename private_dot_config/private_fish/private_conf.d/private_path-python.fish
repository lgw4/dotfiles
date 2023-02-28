if test -d "$HOME/.pyenv"
    set -x PYENV_ROOT $HOME/.pyenv
end

if test -n "$PYENV_ROOT" && test -d "$PYENV_ROOT/bin"
    fish_add_path -mpP $PYENV_ROOT/bin
    function pyenv-update -d "Update pyenv installation"
        set current_directory (pwd)
        printf "Updating pyenv…\n"
        cd $PYENV_ROOT
        git fetch
        git pull
        cd plugins
        for directory in (command ls)
            printf "Updating $directory…\n"
            cd $directory
            git fetch
            git pull
            cd ..
        end
        cd $current_directory
        set -u current_directory
    end
end

if type -q pyenv && status --is-interactive
    set -x PYENV_VIRTUALENV_DISABLE_PROMPT 1
    pyenv init - fish | source
end
