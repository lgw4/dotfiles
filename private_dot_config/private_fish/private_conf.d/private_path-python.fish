if test -d "$HOME/.pyenv"
    set -x PYENV_ROOT $HOME/.pyenv
    path_prepend $PYENV_ROOT/bin
    if type -q pyenv
        and not contains $PYENV_ROOT/shims $PATH
        and status --is-interactive
        set -x PYENV_VIRTUALENV_DISABLE_PROMPT 1
        pyenv init --path | source
        pyenv init - | source
        pyenv virtualenv-init - | source
    end
end
