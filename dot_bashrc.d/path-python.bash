# shellcheck shell=bash
# shellcheck disable=SC1090,SC2207
# Enable pyenv
if [[ -d "$HOME"/.pyenv/bin ]]; then
    path_prepend "$HOME"/.pyenv/bin PATH
fi
if command -v pyenv >/dev/null 2>&1; then
    PYENV_COMPLETION="${HOME}/.pyenv/completions/pyenv.bash"
    if [[ ":${PATH}:" != *":${HOME}/.pyenv/shims:"* ]]; then
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
        export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    elif [[ -r "$PYENV_COMPLETION" ]]; then
        source "$PYENV_COMPLETION"
    fi
    PYENV_PYTHON3="$(pyenv which python3)"
fi

# Enable virtualenvwrapper
if [[ -e "${HOME}"/.local/bin/virtualenvwrapper.sh ]]; then
    VIRTUALENVWRAPPER="${HOME}"/.local/bin/virtualenvwrapper.sh
elif [[ -e /opt/homebrew/bin/virtualenvwrapper.sh ]]; then
    VIRTUALENVWRAPPER=/opt/homebrew/bin/virtualenvwrapper.sh
elif [[ -e /usr/local/bin/virtualenvwrapper.sh ]]; then
    VIRTUALENVWRAPPER=/usr/local/bin/virtualenvwrapper.sh
elif [[ -e /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]]; then
    VIRTUALENVWRAPPER=/usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi
if [[ -v VIRTUALENVWRAPPER ]]; then
    if [[ -v PYENV_PYTHON3 ]]; then
        export VIRTUALENVWRAPPER_PYTHON="${PYENV_PYTHON3}"
    elif [[ -x /usr/local/bin/python3 ]]; then
        export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    elif [[ -x /usr/bin/python3 ]]; then
        export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    fi
    if [[ -d "$HOME"/Developer/python ]]; then
        export PROJECT_HOME="${HOME}"/Developer/python
    else
        export PROJECT_HOME="${HOME}"/devel/python
    fi
    export WORKON_HOME="${HOME}"/.local/share/virtualenvs
    export VIRTUALENVWRAPPER_HOOK_DIR="${WORKON_HOME}"/_hooks
    source "${VIRTUALENVWRAPPER}"
fi

# Enable pip completion
_pip_completion() {
    COMPREPLY=($(COMP_WORDS="${COMP_WORDS[*]}" \
        COMP_CWORD="${COMP_CWORD}" \
        PIP_AUTO_COMPLETE=1 "${1}" 2>/dev/null))
}
complete -o default -F _pip_completion pip
complete -o default -F _pip_completion pip3
complete -o default -F _pip_completion pip3.7
complete -o default -F _pip_completion pip3.8
complete -o default -F _pip_completion pip3.9
