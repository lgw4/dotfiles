if test -d "$HOMEBREW_PREFIX/share/npm/bin"
    fish_add_path -mpP $HOMEBREW_PREFIX/share/npm/bin
end

if test -d "$HOME/.nodenv"
    set -x NODENV_ROOT $HOME/.nodenv
end

if test -n "$NODENV_ROOT" && test -d "$NODENV_ROOT/bin"
    fish_add_path -mpP $NODENV_ROOT/bin
end

if type -q nodenv && status --is-interactive
    nodenv init - fish | source
end
