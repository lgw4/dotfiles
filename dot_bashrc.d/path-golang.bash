# shellcheck shell=bash
# shellcheck disable=SC1091
if [[ ! -v VIRTUAL_ENV ]]; then
    export GOENV_ROOT="$HOME/.goenv"
    if [[ -d "$GOENV_ROOT"/bin ]]; then
        path_prepend "$GOENV_ROOT"/bin
    fi

    if command -v goenv >/dev/null 2>&1; then
        eval "$(goenv init -)"
    fi

    goenv_update() {
        cd "$GOENV_ROOT" || exit
        git fetch
        git pull origin master
        cd "$HOME" || exit
    }

    if [[ -d "$HOME"/Developer/go ]]; then
        export GOPATH="${HOME}/Developer/go"
    elif [[ -d "$HOME"/devel/go ]]; then
        export GOPATH="${HOME}/devel/go"
    fi

    if [[ -n "$GOPATH" ]]; then
        path_append "$GOPATH"/bin PATH
    fi
fi
