if test -d "$HOMEBREW_ROOT/share/npm/bin"
    path_prepend $HOMEBREW_ROOT/share/npm/bin
end

if test -d "$HOME/.nodenv"
    set -x NODENV_ROOT $HOME/.nodenv
    path_prepend $NODENV_ROOT/bin
    if type -q nodenv
        and not contains $NODENV_ROOT/shims $PATH
        and status --is-interactive
        nodenv init - | source
    end
end
