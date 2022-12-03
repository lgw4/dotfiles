if test -d "$HOME/.pyenv"
    set -x PYENV_ROOT $HOME/.pyenv
end

if test -n "$PYENV_ROOT" && test -d "$PYENV_ROOT/bin"
    fish_add_path -mpP $PYENV_ROOT/bin
end

if type -q pyenv
    and not contains $PYENV_ROOT/shims $PATH
    and status --is-interactive
    set -x PYENV_VIRTUALENV_DISABLE_PROMPT 1
    pyenv init - | source
end
