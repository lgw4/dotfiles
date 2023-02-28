if test -d "$HOME/.rbenv"
    set -x RBENV_ROOT $HOME/.rbenv
end

if test -n "$RBENV_ROOT" && test -d "$RBENV_ROOT/bin"
    fish_add_path -mpP $RBENV_ROOT/bin
    function rbenv-update -d "Update rbenv installation"
        set current_directory (pwd)
        printf "Updating rbenv…\n"
        cd $RBENV_ROOT
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

if type -q rbenv && status --is-interactive
    rbenv init - fish | source
end
