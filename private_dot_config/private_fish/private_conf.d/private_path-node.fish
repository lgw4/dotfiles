if test -d "$HOMEBREW_PREFIX/share/npm/bin"
    fish_add_path -mpP $HOMEBREW_PREFIX/share/npm/bin
end

if test -d "$HOME/.nodenv"
    set -x NODENV_ROOT $HOME/.nodenv
end

if test -n "$NODENV_ROOT" && test -d "$NODENV_ROOT/bin"
    fish_add_path -mpP $NODENV_ROOT/bin
    function nodenv-update -d "Update nodenv installation"
        set current_directory (pwd)
        printf "Updating nodenv…\n"
        cd $NODENV_ROOT
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

if type -q nodenv && status --is-interactive
    nodenv init - fish | source
end
