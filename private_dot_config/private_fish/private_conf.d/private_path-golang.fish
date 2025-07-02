if type -q goenv && status --is-interactive
    goenv init - fish | source
end

if test -d "$HOME/.goenv"
    set -x GOENV_ROOT $HOME/.goenv
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
