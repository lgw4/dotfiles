#!/usr/bin/env zsh
# Enable pyenv
if [[ -d "${HOME}/.pyenv" ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
fi

if [[ -v PYENV_ROOT ]] && [[ -d "${PYENV_ROOT}/bin" ]]; then
    path_prepend "${PYENV_ROOT}/bin"
fi

if (( ${+commands[pyenv]} )); then
    eval "$(pyenv init -)"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi

# Enable virtualenvwrapper
if [[ -e "${HOME}/.local/bin/virtualenvwrapper.sh" ]]; then
    VIRTUALENVWRAPPER="${HOME}/.local/bin/virtualenvwrapper.sh"
elif [[ -e "/opt/homebrew/bin/virtualenvwrapper.sh" ]]; then
    VIRTUALENVWRAPPER="/opt/homebrew/bin/virtualenvwrapper.sh"
elif [[ -e "/usr/local/bin/virtualenvwrapper.sh" ]]; then
    VIRTUALENVWRAPPER="/usr/local/bin/virtualenvwrapper.sh"
elif [[ -e "/usr/share/virtualenvwrapper/virtualenvwrapper.sh" ]]; then
    VIRTUALENVWRAPPER="/usr/share/virtualenvwrapper/virtualenvwrapper.sh"
fi
if [[ -v VIRTUALENVWRAPPER ]]; then
    if [[ -x "/opt/homebrew/bin/python3" ]]; then
        export VIRTUALENVWRAPPER_PYTHON="/opt/homebrew/bin/python3"
    elif [[ -x "/usr/local/bin/python3" ]]; then
        export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python3"
    elif [[ -x "/usr/bin/python3" ]]; then
        export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"
    fi
    if [[ -d "${HOME}/Developer/python" ]]; then
        export PROJECT_HOME="${HOME}/Developer/python"
    else
        export PROJECT_HOME="${HOME}/devel/python"
    fi
    export WORKON_HOME="${HOME}/.local/share/virtualenvs"
    export VIRTUALENVWRAPPER_HOOK_DIR="${WORKON_HOME}/_hooks"
    source "${VIRTUALENVWRAPPER}"
fi
