if test -d "$HOME/.goenv"
    set -x GOENV_ROOT $HOME/.goenv
    path_prepend $GOENV_ROOT/bin
    if type -q goenv
        and not contains $GOENV_ROOT/shims $PATH
        and status --is-interactive
        goenv init - | source
    end
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
    path_prepend $GOPATH/bin
end
