#!/usr/bin/env zsh
# Enable pyenv
if [[ -d "$HOME"/.pyenv ]]; then
    export PYENV_ROOT="$HOME"/.pyenv
fi

if [[ -d "$PYENV_ROOT"/bin ]]; then
    path_prepend "$PYENV_ROOT"/bin
fi

if command -v pyenv >/dev/null 2>&1 && [[ ":${PATH}:" != *":${HOME}/.pyenv/shims:"* ]]; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi

# Enable pip completion
_pip_completion() {
    COMPREPLY=($(COMP_WORDS="${COMP_WORDS[*]}" \
        COMP_CWORD="$COMP_CWORD" \
        PIP_AUTO_COMPLETE=1 "$1"))
}
complete -o default -F _pip_completion pip
complete -o default -F _pip_completion pip3
complete -o default -F _pip_completion pip3.7
complete -o default -F _pip_completion pip3.8
complete -o default -F _pip_completion pip3.9
