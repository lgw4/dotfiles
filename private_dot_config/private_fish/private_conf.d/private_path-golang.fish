if test -d "$HOME/.goenv"
    set -x GOENV_ROOT $HOME/.goenv
end

if test -n "$GOENV_ROOT" && test -d "$GOENV_ROOT/bin"
    fish_add_path -mpP $GOENV_ROOT/bin
    function goenv-update -d "Update goenv installation"
        set current_directory (pwd)
        printf "Updating goenv…\n"
        cd $GOENV_ROOT
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

if type -q goenv && status --is-interactive
    goenv init - fish | source
    fish_add_path -mpP $GOENV_ROOT/shims
end


if test -d "$HOME/Developer/go"
    set -x GOPATH $HOME/Developer/go
else if test -d "$HOME/devel/go"
    set -x GOPATH $HOME/devel/go
end

if test -n "$GOENV_ROOT" -a -n "$GOPATH"
    set -x GOENV_GOPATH_PREFIX $GOPATH
end

if test -n "$GOPATH"
    and not contains $GOPATH/bin $PATH
    fish_add_path -mpP $GOPATH/bin
end
