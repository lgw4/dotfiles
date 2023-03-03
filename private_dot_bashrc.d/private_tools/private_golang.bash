# shellcheck shell=bash
# shellcheck disable=SC2103,SC2155,SC2164
if [[ -d "$HOME/.goenv" ]]; then
    export GOENV_ROOT="$HOME/.goenv"
fi

if [[ -v GOENV_ROOT ]] && [[ -d "$GOENV_ROOT/bin" ]]; then
    path_prepend "$GOENV_ROOT/bin"
    goenv-update () {
        local current_directory=$(pwd)
        cd "$GOENV_ROOT"
        git fetch
        git pull
        cd plugins
        for directory in $(command ls); do
            printf "Updating %s…\n" "$directory"
            cd "$directory"
            git fetch
            git pull
            cd ..
        done
        cd "$current_directory"
        unset current_directory
    }
fi

if command -v goenv >/dev/null 2>&1; then
    eval "$(goenv init -)"
    path_prepend "$GOENV_ROOT/shims"
fi

if [[ -d "$HOME/Developer/go" ]]; then
    export GOPATH="$HOME/Developer/go"
elif [[ -d "$HOME/devel/go" ]]; then
    export GOPATH="$HOME/devel/go"
fi

if [[ -n "$GOPATH" ]]; then
    path_append "$GOPATH/bin"
fi

if [[ -n "$GOENV_ROOT" ]] && [[ -n "$GOPATH" ]]; then
    export GOENV_GOPATH_PREFIX="$GOPATH"
fi
