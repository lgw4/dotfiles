if test -d "$HOME/.rbenv"
    set -x RBENV_ROOT $HOME/.rbenv
end

if test -n "$RBENV_ROOT" && test -d "$RBENV_ROOT/bin"
    fish_add_path -mpP $RBENV_ROOT/bin
end

if type -q rbenv && status --is-interactive
    rbenv init - fish | source
end
